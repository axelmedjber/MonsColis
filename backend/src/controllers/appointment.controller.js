const { Appointment } = require('../models/appointment.model');
const { Store } = require('../models/store.model');
const { redis } = require('../services/redis.service');
const { sendSMS } = require('../services/sms.service');

class AppointmentController {
  async listAppointments(req, res) {
    try {
      const { status, from_date, to_date } = req.query;
      const cacheKey = `appointments:${req.user.id}:${status || 'all'}:${from_date}:${to_date}`;

      // Try cache first
      const cachedAppointments = await redis.get(cacheKey);
      if (cachedAppointments) {
        return res.json({ appointments: JSON.parse(cachedAppointments) });
      }

      let query = Appointment.query()
        .where('user_id', req.user.id)
        .withGraphFetched('[store, visit]')
        .orderBy('appointment_time', 'asc');

      if (status) {
        query = query.where('status', status);
      }

      if (from_date) {
        query = query.where('appointment_time', '>=', from_date);
      }

      if (to_date) {
        query = query.where('appointment_time', '<=', to_date);
      }

      const appointments = await query;

      // Cache for 5 minutes
      await redis.set(cacheKey, JSON.stringify(appointments), 'EX', 300);

      res.json({ appointments });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async createAppointment(req, res) {
    try {
      const { store_id, appointment_time } = req.body;

      // Check store availability
      const store = await Store.query()
        .findById(store_id)
        .withGraphFetched('appointments(forTimeSlot)')
        .modifiers({
          forTimeSlot: builder => {
            builder.where('appointment_time', appointment_time)
              .andWhere('status', 'scheduled');
          }
        });

      if (!store) {
        return res.status(404).json({ message: 'Store not found' });
      }

      if (store.appointments.length >= store.capacity) {
        return res.status(400).json({ message: 'Time slot is fully booked' });
      }

      // Generate unique confirmation code
      const confirmationCode = await this.generateUniqueCode();

      const appointment = await Appointment.query().insert({
        user_id: req.user.id,
        store_id,
        appointment_time,
        status: 'scheduled',
        confirmation_code: confirmationCode
      });

      // Send confirmation SMS
      await sendSMS(
        req.user.phone_number,
        `Your MonsColis appointment is confirmed for ${appointment_time}. Your code: ${confirmationCode}`
      );

      // Invalidate cache
      await redis.del(`appointments:${req.user.id}:all`);

      res.status(201).json({ appointment });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async cancelAppointment(req, res) {
    try {
      const { id } = req.params;

      const appointment = await Appointment.query()
        .patchAndFetchById(id, { status: 'cancelled' })
        .where('user_id', req.user.id)
        .andWhere('status', 'scheduled');

      if (!appointment) {
        return res.status(404).json({ message: 'Appointment not found or already cancelled' });
      }

      // Invalidate cache
      await redis.del(`appointments:${req.user.id}:all`);

      // Send cancellation SMS
      await sendSMS(
        req.user.phone_number,
        `Your MonsColis appointment for ${appointment.appointment_time} has been cancelled.`
      );

      res.json({ appointment });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async verifyAppointment(req, res) {
    try {
      const { confirmation_code } = req.body;

      const appointment = await Appointment.query()
        .where('confirmation_code', confirmation_code)
        .andWhere('status', 'scheduled')
        .first();

      if (!appointment) {
        return res.status(404).json({ message: 'Invalid or expired confirmation code' });
      }

      res.json({ appointment });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async generateUniqueCode() {
    const code = Math.random().toString(36).substring(2, 8).toUpperCase();
    const exists = await Appointment.query()
      .where('confirmation_code', code)
      .first();
    
    if (exists) {
      return this.generateUniqueCode();
    }
    
    return code;
  }
}

module.exports = new AppointmentController();
