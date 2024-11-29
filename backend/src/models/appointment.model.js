const { Model } = require('objection');

class Appointment extends Model {
  static get tableName() {
    return 'appointments';
  }

  static get jsonSchema() {
    return {
      type: 'object',
      required: ['user_id', 'store_id', 'appointment_time'],
      properties: {
        id: { type: 'string', format: 'uuid' },
        user_id: { type: 'string', format: 'uuid' },
        store_id: { type: 'string', format: 'uuid' },
        appointment_time: { type: 'string', format: 'date-time' },
        status: { 
          type: 'string',
          enum: ['scheduled', 'completed', 'cancelled']
        },
        confirmation_code: { type: 'string' },
        created_at: { type: 'string', format: 'date-time' },
        updated_at: { type: 'string', format: 'date-time' }
      }
    };
  }

  static get relationMappings() {
    const User = require('./user.model');
    const Store = require('./store.model');
    const Visit = require('./visit.model');

    return {
      user: {
        relation: Model.BelongsToOneRelation,
        modelClass: User,
        join: {
          from: 'appointments.user_id',
          to: 'users.id'
        }
      },
      store: {
        relation: Model.BelongsToOneRelation,
        modelClass: Store,
        join: {
          from: 'appointments.store_id',
          to: 'stores.id'
        }
      },
      visit: {
        relation: Model.HasOneRelation,
        modelClass: Visit,
        join: {
          from: 'appointments.id',
          to: 'visits.appointment_id'
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
