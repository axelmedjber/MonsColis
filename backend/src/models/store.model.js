const { Model } = require('objection');

class Store extends Model {
  static get tableName() {
    return 'stores';
  }

  static get jsonSchema() {
    return {
      type: 'object',
      required: ['name', 'address', 'capacity'],
      properties: {
        id: { type: 'string', format: 'uuid' },
        name: { type: 'string', minLength: 1 },
        address: { type: 'string', minLength: 1 },
        capacity: { type: 'integer', minimum: 1 },
        operating_hours: {
          type: 'object',
          properties: {
            monday: { type: 'array', items: { type: 'string' } },
            tuesday: { type: 'array', items: { type: 'string' } },
            wednesday: { type: 'array', items: { type: 'string' } },
            thursday: { type: 'array', items: { type: 'string' } },
            friday: { type: 'array', items: { type: 'string' } },
            saturday: { type: 'array', items: { type: 'string' } },
            sunday: { type: 'array', items: { type: 'string' } }
          }
        },
        admin_id: { type: 'string', format: 'uuid' },
        created_at: { type: 'string', format: 'date-time' },
        updated_at: { type: 'string', format: 'date-time' }
      }
    };
  }

  static get relationMappings() {
    const User = require('./user.model');
    const Appointment = require('./appointment.model');

    return {
      admin: {
        relation: Model.BelongsToOneRelation,
        modelClass: User,
        join: {
          from: 'stores.admin_id',
          to: 'users.id'
        }
      },
      appointments: {
        relation: Model.HasManyRelation,
        modelClass: Appointment,
        join: {
          from: 'stores.id',
          to: 'appointments.store_id'
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
