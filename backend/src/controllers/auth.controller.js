const jwt = require('jsonwebtoken');
const { User } = require('../models/user.model');
const { sendSMS } = require('../services/sms.service');
const { redis } = require('../services/redis.service');

class AuthController {
  async sendVerificationCode(req, res) {
    try {
      const { phone_number } = req.body;
      const verificationCode = Math.floor(100000 + Math.random() * 900000);
      
      // Store verification code in Redis with 5 minutes expiry
      await redis.set(
        `verification:${phone_number}`,
        verificationCode,
        'EX',
        300
      );

      // Send SMS
      await sendSMS(
        phone_number,
        `Your MonsColis verification code is: ${verificationCode}`
      );

      res.json({ message: 'Verification code sent' });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async verifyPhoneNumber(req, res) {
    try {
      const { phone_number, verification_code } = req.body;
      
      // Get stored code from Redis
      const storedCode = await redis.get(`verification:${phone_number}`);
      
      if (!storedCode || storedCode !== verification_code) {
        return res.status(400).json({ message: 'Invalid verification code' });
      }

      // Find or create user
      let user = await User.query()
        .findOne({ phone_number })
        .select('id', 'phone_number', 'role', 'is_verified');

      if (!user) {
        user = await User.query().insert({
          phone_number,
          role: 'beneficiary',
          is_verified: false
        });
      }

      // Generate JWT token
      const token = jwt.sign(
        { userId: user.id },
        process.env.JWT_SECRET,
        { expiresIn: process.env.JWT_EXPIRES_IN }
      );

      res.json({
        token,
        user: {
          id: user.id,
          phone_number: user.phone_number,
          role: user.role,
          is_verified: user.is_verified
        }
      });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async getCurrentUser(req, res) {
    try {
      const user = await User.query()
        .findById(req.user.id)
        .select('id', 'phone_number', 'display_name', 'role', 'is_verified', 'profile_data');

      res.json({ user });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async updateProfile(req, res) {
    try {
      const { display_name, profile_data } = req.body;
      
      const updatedUser = await User.query()
        .patchAndFetchById(req.user.id, {
          display_name,
          profile_data
        })
        .select('id', 'phone_number', 'display_name', 'role', 'is_verified', 'profile_data');

      res.json({ user: updatedUser });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

module.exports = new AuthController();
