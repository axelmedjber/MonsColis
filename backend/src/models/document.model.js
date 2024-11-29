const { Model } = require('objection');

class Document extends Model {
  static get tableName() {
    return 'documents';
  }

  static get jsonSchema() {
    return {
      type: 'object',
      required: ['user_id', 'document_type', 'file_path'],
      properties: {
        id: { type: 'string', format: 'uuid' },
        user_id: { type: 'string', format: 'uuid' },
        document_type: { type: 'string' },
        file_path: { type: 'string' },
        status: {
          type: 'string',
          enum: ['pending', 'approved', 'rejected']
        },
        rejection_reason: { type: 'string' },
        created_at: { type: 'string', format: 'date-time' },
        updated_at: { type: 'string', format: 'date-time' }
      }
    };
  }

  static get relationMappings() {
    const User = require('./user.model');

    return {
      user: {
        relation: Model.BelongsToOneRelation,
        modelClass: User,
        join: {
          from: 'documents.user_id',
          to: 'users.id'
        }
      }
    };
  }

  async $beforeInsert(context) {
    await super.$beforeInsert(context);
    this.created_at = new Date().toISOString();
    this.updated_at = new Date().toISOString();
  }

  async $beforeUpdate(opt, context) {
    await super.$beforeUpdate(opt, context);
    this.updated_at = new Date().toISOString();
  }
}
