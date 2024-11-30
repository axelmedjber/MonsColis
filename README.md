# MonsColis - Social Grocery Management System

MonsColis is a modern social grocery management system that helps users manage their grocery shopping and share lists with friends and family.

## Project Structure

```
monscolis/
├── .github/            # GitHub Actions workflows
├── backend/           # Node.js backend server
│   ├── src/
│   │   ├── config/    # Configuration files
│   │   ├── controllers/# Route controllers
│   │   ├── middleware/# Express middleware
│   │   ├── models/    # Database models
│   │   ├── routes/    # API routes
│   │   ├── services/  # Business logic
│   │   └── utils/     # Utility functions
│   ├── __tests__/     # Test files
│   └── migrations/    # Database migrations
├── mobile/           # Flutter mobile app
└── assets/          # Shared assets
```

## Backend Setup

### Prerequisites

- Node.js >= 18.0.0
- PostgreSQL >= 13
- Redis >= 6
- MinIO (for file storage)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/monscolis.git
   cd monscolis
   ```

2. Install backend dependencies:
   ```bash
   cd backend
   npm install
   ```

3. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. Run database migrations:
   ```bash
   npm run migrate
   ```

5. Start the development server:
   ```bash
   npm run dev
   ```

### Available Scripts

- `npm start`: Start production server
- `npm run dev`: Start development server with hot reload
- `npm test`: Run tests with coverage
- `npm run lint`: Lint code
- `npm run format`: Format code with Prettier
- `npm run migrate`: Run database migrations
- `npm run migrate:rollback`: Rollback last migration
- `npm run seed`: Seed database with sample data
- `npm run validate`: Run linting and tests

## API Documentation

API documentation is available at `/api-docs` when running the server.

### Key Endpoints

- `GET /health`: Health check endpoint
- `POST /api/auth/register`: Register new user
- `POST /api/auth/login`: Login user
- `GET /api/lists`: Get user's grocery lists
- `POST /api/lists`: Create new grocery list
- `PUT /api/lists/:id`: Update grocery list
- `DELETE /api/lists/:id`: Delete grocery list

## Mobile App Setup

See [mobile/README.md](mobile/README.md) for mobile app setup instructions.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
