exports.up = function(knex) {
  return knex.schema
    .createTable('users', table => {
      table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
      table.string('phone_number').unique().notNullable();
      table.string('display_name');
      table.enum('role', ['beneficiary', 'store_admin', 'admin']).defaultTo('beneficiary');
      table.boolean('is_verified').defaultTo(false);
      table.jsonb('profile_data');
      table.timestamps(true, true);
    })
    .createTable('stores', table => {
      table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
      table.string('name').notNullable();
      table.string('address').notNullable();
      table.integer('capacity').notNullable();
      table.jsonb('operating_hours');
      table.uuid('admin_id').references('id').inTable('users');
      table.timestamps(true, true);
    })
    .createTable('documents', table => {
      table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
      table.uuid('user_id').references('id').inTable('users').onDelete('CASCADE');
      table.string('document_type').notNullable();
      table.string('file_path').notNullable();
      table.enum('status', ['pending', 'approved', 'rejected']).defaultTo('pending');
      table.string('rejection_reason');
      table.timestamps(true, true);
    })
    .createTable('appointments', table => {
      table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
      table.uuid('user_id').references('id').inTable('users').onDelete('CASCADE');
      table.uuid('store_id').references('id').inTable('stores').onDelete('CASCADE');
      table.timestamp('appointment_time').notNullable();
      table.enum('status', ['scheduled', 'completed', 'cancelled']).defaultTo('scheduled');
      table.string('confirmation_code').unique();
      table.timestamps(true, true);
    })
    .createTable('visits', table => {
      table.uuid('id').primary().defaultTo(knex.raw('gen_random_uuid()'));
      table.uuid('appointment_id').references('id').inTable('appointments').onDelete('CASCADE');
      table.timestamp('check_in_time');
      table.timestamp('check_out_time');
      table.jsonb('items_collected');
      table.timestamps(true, true);
    });
};

exports.down = function(knex) {
  return knex.schema
    .dropTable('visits')
    .dropTable('appointments')
    .dropTable('documents')
    .dropTable('stores')
    .dropTable('users');
};
