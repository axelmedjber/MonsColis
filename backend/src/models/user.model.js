const { Model } = require('objection');
const bcrypt = require('bcrypt');

class User extends Model {
  static get tableName() {
    return 'users';
  }

  static get jsonSchema() {
    return {
      type: 'object',
      required: ['phone_number'],
      properties: {
        id: { type: 'string', format: 'uuid' },
        phone_number: { type: 'string', minLength: 1 },
        display_name: { type: 'string' },
        role: { type: 'string', enum: ['beneficiary', 'store_admin', 'admin'] },
        is_verified: { type: 'boolean' },
        profile_data: { type: 'object' },
        created_at: { type: 'string', format: 'date-time' },
        updated_at: { type: 'string', format: 'date-time' },
      },
    };
  }

  static get relationMappings() {
    const Store = require('./store.model');
    const Document = require('./document.model');
    const Appointment = require('./appointment.model');

    return {
      managedStores: {
        relation: Model.HasManyRelation,
        modelClass: Store,
        join: {
          from: 'users.id',
          to: 'stores.admin_id',
        },
      },
      documents: {
        relation: Model.HasManyRelation,
        modelClass: Document,
        join: {
          from: 'users.id',
          to: 'documents.user_id',
        },
      },
      appointments: {
        relation: Model.HasManyRelation,
        modelClass: Appointment,
        join: {
          from: 'users.id',
          to: 'appointments.user_id',
        },
      },
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

module.exports = User;
