# MonsColis Social Grocery Platform

A comprehensive mobile application to streamline social grocery services in Mons, Belgium, connecting beneficiaries with local social grocery stores through an efficient, user-friendly platform.

![MonsColis Logo](assets/logo.png)

![CI/CD](https://github.com/axelmedjber/MonsColis/workflows/Flutter%20CI%2FCD/badge.svg)
![CI/CD](https://github.com/axelmedjber/MonsColis/workflows/Node.js%20CI%2FCD/badge.svg)

[![Flutter CI/CD](https://github.com/yourusername/MonsColis/actions/workflows/flutter.yml/badge.svg)](https://github.com/yourusername/MonsColis/actions/workflows/flutter.yml)
[![Node.js CI/CD](https://github.com/yourusername/MonsColis/actions/workflows/node.yml/badge.svg)](https://github.com/yourusername/MonsColis/actions/workflows/node.yml)

## Features

- **Authentication**
  - Phone number verification
  - Role-based access control
  - Secure credential management

- **Store Management**
  - Store listings with real-time capacity
  - Detailed store information
  - Operating hours display
  - Smart appointment scheduling

- **Appointment System**
  - Intuitive booking interface
  - Real-time availability
  - Appointment reminders
  - Cancellation management

- **Document Management**
  - Secure document upload
  - Status tracking
  - Admin review system
  - Document history

- **User Profile**
  - Multi-language support (EN, FR, NL)
  - Customizable settings
  - Dark mode
  - Notification preferences

- **Help & Support**
  - Comprehensive FAQ
  - Direct contact options
  - Support ticket system
  - User guides

## Technical Stack

### Mobile App (Flutter)
- State Management: BLoC pattern
- Local Storage: Hive
- API Client: Dio
- Testing: Flutter Test, Integration Tests
- CI/CD: GitHub Actions

### Backend (Node.js)
- Framework: Express
- Database: PostgreSQL
- Caching: Redis
- Authentication: JWT
- Testing: Jest
- CI/CD: GitHub Actions

## Getting Started

### Prerequisites
- Flutter SDK (3.x)
- Node.js (16.x or 18.x)
- PostgreSQL (13+)
- Redis
- Android Studio / Xcode

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/MonsColis.git
   cd MonsColis
   ```

2. **Backend Setup**
   ```bash
   cd backend
   npm install
   cp .env.example .env  # Configure your environment variables
   npm run migrate
   npm run dev
   ```

3. **Mobile App Setup**
   ```bash
   cd mobile
   flutter pub get
   flutter run
   ```

### Environment Variables

#### Backend (.env)
```
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/monscolis
REDIS_URL=redis://localhost:6379
JWT_SECRET=your_jwt_secret
SMS_API_KEY=your_sms_api_key
```

#### Mobile (lib/config/env.dart)
```dart
const API_BASE_URL = 'http://localhost:3000';
const SMS_VERIFICATION_ENABLED = true;
```

## Testing

### Running Backend Tests
```bash
cd backend
npm test                 # Run unit tests
npm run test:coverage    # Generate coverage report
```

### Running Mobile Tests
```bash
cd mobile
flutter test                    # Run unit tests
flutter test integration_test   # Run integration tests
```

## Deployment

### Backend Deployment (Heroku)
1. Create a new Heroku app
2. Configure environment variables
3. Push to Heroku:
   ```bash
   git subtree push --prefix backend heroku main
   ```

### Mobile App Distribution (Firebase)
1. Configure Firebase App Distribution
2. Push to main branch
3. GitHub Actions will automatically:
   - Build the APK
   - Deploy to Firebase
   - Distribute to testers

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Team

- Project Lead: [Your Name](https://github.com/yourusername)
- Backend Developer: [Name](https://github.com/username)
- Mobile Developer: [Name](https://github.com/username)
- UI/UX Designer: [Name](https://github.com/username)

## Support

For support, email support@monscolis.be or join our Slack channel.
