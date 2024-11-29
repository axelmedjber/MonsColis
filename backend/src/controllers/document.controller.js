const { Document } = require('../models/document.model');
const { minio } = require('../services/minio.service');
const { redis } = require('../services/redis.service');
const { sendSMS } = require('../services/sms.service');

class DocumentController {
  async listDocuments(req, res) {
    try {
      const cacheKey = `documents:${req.user.id}`;

      // Try cache first
      const cachedDocs = await redis.get(cacheKey);
      if (cachedDocs) {
        return res.json({ documents: JSON.parse(cachedDocs) });
      }

      const documents = await Document.query()
        .where('user_id', req.user.id)
        .orderBy('created_at', 'desc');

      // Cache for 5 minutes
      await redis.set(cacheKey, JSON.stringify(documents), 'EX', 300);

      res.json({ documents });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async uploadDocument(req, res) {
    try {
      const { document_type } = req.body;
      const file = req.file;

      if (!file) {
        return res.status(400).json({ message: 'No file uploaded' });
      }

      // Generate unique filename
      const filename = `${req.user.id}/${document_type}/${Date.now()}-${file.originalname}`;

      // Upload to MinIO
      await minio.putObject('documents', filename, file.buffer, {
        'Content-Type': file.mimetype,
        'Content-Length': file.size
      });

      const document = await Document.query().insert({
        user_id: req.user.id,
        document_type,
        file_path: filename,
        status: 'pending'
      });

      // Invalidate cache
      await redis.del(`documents:${req.user.id}`);

      res.status(201).json({ document });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async reviewDocument(req, res) {
    try {
      const { id } = req.params;
      const { status, rejection_reason } = req.body;

      const document = await Document.query()
        .findById(id)
        .withGraphFetched('user');

      if (!document) {
        return res.status(404).json({ message: 'Document not found' });
      }

      const updatedDoc = await Document.query()
        .patchAndFetchById(id, {
          status,
          rejection_reason: status === 'rejected' ? rejection_reason : null
        });

      // Invalidate cache
      await redis.del(`documents:${document.user_id}`);

      // Send notification to user
      const message = status === 'approved'
        ? 'Your document has been approved!'
        : `Your document was rejected. Reason: ${rejection_reason}`;

      await sendSMS(document.user.phone_number, message);

      res.json({ document: updatedDoc });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async getDocumentUrl(req, res) {
    try {
      const { id } = req.params;

      const document = await Document.query()
        .findById(id)
        .where('user_id', req.user.id);

      if (!document) {
        return res.status(404).json({ message: 'Document not found' });
      }

      // Generate presigned URL valid for 15 minutes
      const url = await minio.presignedGetObject('documents', document.file_path, 15 * 60);

      res.json({ url });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new DocumentController();
