const { Store } = require('../models/store.model');
const { redis } = require('../services/redis.service');

class StoreController {
  async listStores(req, res) {
    try {
      // Try to get from cache first
      const cachedStores = await redis.get('stores:all');
      if (cachedStores) {
        return res.json({ stores: JSON.parse(cachedStores) });
      }

      const stores = await Store.query()
        .select('id', 'name', 'address', 'capacity', 'operating_hours')
        .withGraphFetched('admin(selectBasic)')
        .modifiers({
          selectBasic: builder => {
            builder.select('id', 'display_name', 'phone_number');
          }
        });

      // Cache for 5 minutes
      await redis.set('stores:all', JSON.stringify(stores), 'EX', 300);

      res.json({ stores });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async getStore(req, res) {
    try {
      const { id } = req.params;
      const cacheKey = `store:${id}`;
      
      // Try cache first
      const cachedStore = await redis.get(cacheKey);
      if (cachedStore) {
        return res.json({ store: JSON.parse(cachedStore) });
      }

      const store = await Store.query()
        .findById(id)
        .withGraphFetched('[admin(selectBasic), appointments(upcoming)]')
        .modifiers({
          selectBasic: builder => {
            builder.select('id', 'display_name', 'phone_number');
          },
          upcoming: builder => {
            builder.where('appointment_time', '>', new Date())
              .orderBy('appointment_time', 'asc');
          }
        });

      if (!store) {
        return res.status(404).json({ message: 'Store not found' });
      }

      // Cache for 5 minutes
      await redis.set(cacheKey, JSON.stringify(store), 'EX', 300);

      res.json({ store });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async createStore(req, res) {
    try {
      const { name, address, capacity, operating_hours } = req.body;

      const store = await Store.query().insert({
        name,
        address,
        capacity,
        operating_hours,
        admin_id: req.user.id
      });

      // Invalidate cache
      await redis.del('stores:all');

      res.status(201).json({ store });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async updateStore(req, res) {
    try {
      const { id } = req.params;
      const { name, address, capacity, operating_hours } = req.body;

      const store = await Store.query()
        .patchAndFetchById(id, {
          name,
          address,
          capacity,
          operating_hours
        })
        .where('admin_id', req.user.id);

      if (!store) {
        return res.status(404).json({ message: 'Store not found or unauthorized' });
      }

      // Invalidate cache
      await redis.del(`store:${id}`);
      await redis.del('stores:all');

      res.json({ store });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }

  async getStoreAvailability(req, res) {
    try {
      const { id } = req.params;
      const { date } = req.query;

      const store = await Store.query()
        .findById(id)
        .select('capacity')
        .withGraphFetched('appointments(forDate)')
        .modifiers({
          forDate: builder => {
            builder.where('appointment_time', '>=', `${date} 00:00:00`)
              .andWhere('appointment_time', '<=', `${date} 23:59:59`);
          }
        });

      if (!store) {
        return res.status(404).json({ message: 'Store not found' });
      }

      const timeSlots = generateTimeSlots(store.operating_hours);
      const availability = calculateAvailability(timeSlots, store.capacity, store.appointments);

      res.json({ availability });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
}

function generateTimeSlots(operatingHours) {
  // Implementation of time slot generation based on operating hours
  // This would return available time slots for the store
  return [];
}

function calculateAvailability(timeSlots, capacity, appointments) {
  // Implementation of availability calculation
  // This would return available slots with remaining capacity
  return [];
}

module.exports = new StoreController();
