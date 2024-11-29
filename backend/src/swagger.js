module.exports = {
  openapi: '3.0.0',
  info: {
    title: 'MonsColis API',
    version: '1.0.0',
    description: 'API documentation for MonsColis social grocery management system'
  },
  servers: [
    {
      url: 'http://localhost:3000/api',
      description: 'Development server'
    }
  ],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT'
      }
    },
    schemas: {
      User: {
        type: 'object',
        properties: {
          id: { type: 'string', format: 'uuid' },
          phone_number: { type: 'string' },
          display_name: { type: 'string' },
          role: { type: 'string', enum: ['beneficiary', 'store_admin', 'admin'] },
          is_verified: { type: 'boolean' },
          profile_data: { type: 'object' }
        }
      },
      Store: {
        type: 'object',
        properties: {
          id: { type: 'string', format: 'uuid' },
          name: { type: 'string' },
          address: { type: 'string' },
          capacity: { type: 'integer' },
          operating_hours: { type: 'object' }
        }
      },
      Appointment: {
        type: 'object',
        properties: {
          id: { type: 'string', format: 'uuid' },
          user_id: { type: 'string', format: 'uuid' },
          store_id: { type: 'string', format: 'uuid' },
          appointment_time: { type: 'string', format: 'date-time' },
          status: { type: 'string', enum: ['scheduled', 'completed', 'cancelled'] },
          confirmation_code: { type: 'string' }
        }
      }
    }
  },
  paths: {
    '/auth/send-code': {
      post: {
        tags: ['Authentication'],
        summary: 'Send verification code',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  phone_number: { type: 'string' }
                }
              }
            }
          }
        },
        responses: {
          200: {
            description: 'Verification code sent successfully'
          }
        }
      }
    },
    '/auth/verify': {
      post: {
        tags: ['Authentication'],
        summary: 'Verify phone number',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  phone_number: { type: 'string' },
                  verification_code: { type: 'string' }
                }
              }
            }
          }
        },
        responses: {
          200: {
            description: 'User verified successfully',
            content: {
              'application/json': {
                schema: {
                  type: 'object',
                  properties: {
                    token: { type: 'string' },
                    user: { $ref: '#/components/schemas/User' }
                  }
                }
              }
            }
          }
        }
      }
    },
    '/appointments': {
      get: {
        tags: ['Appointments'],
        security: [{ bearerAuth: [] }],
        summary: 'Get user appointments',
        responses: {
          200: {
            description: 'List of appointments',
            content: {
              'application/json': {
                schema: {
                  type: 'array',
                  items: { $ref: '#/components/schemas/Appointment' }
                }
              }
            }
          }
        }
      },
      post: {
        tags: ['Appointments'],
        security: [{ bearerAuth: [] }],
        summary: 'Create new appointment',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  store_id: { type: 'string', format: 'uuid' },
                  appointment_time: { type: 'string', format: 'date-time' }
                }
              }
            }
          }
        },
        responses: {
          201: {
            description: 'Appointment created successfully',
            content: {
              'application/json': {
                schema: { $ref: '#/components/schemas/Appointment' }
              }
            }
          }
        }
      }
    }
  }
};
