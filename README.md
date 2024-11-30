# MonsColis 

![CI/CD](https://github.com/axelmedjber/MonsColis/workflows/Flutter%20CI%2FCD/badge.svg)
![CI/CD](https://github.com/axelmedjber/MonsColis/workflows/Node.js%20CI%2FCD/badge.svg)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## About MonsColis

MonsColis is a comprehensive mobile application designed to streamline social grocery services in Mons, Belgium. The platform connects beneficiaries with local social grocery stores through an efficient, user-friendly interface.

### Key Features

- Cross-platform mobile application (iOS & Android)
- Secure authentication with phone verification
- Real-time store capacity tracking
- Smart appointment scheduling
- Digital document management
- Multi-language support (FR, EN, NL)
- Dark mode support
- Push notifications

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Node.js (v16.x or later)
- PostgreSQL (v13 or later)
- Redis
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/axelmedjber/MonsColis.git
cd MonsColis
```

2. Set up the development environment
```powershell
.\scripts\setup.ps1
```

3. Configure environment variables
```bash
# Backend
cd backend
cp .env.example .env
# Edit .env with your configurations

# Mobile
cd ../mobile
# Add your Firebase configuration files
```

## Architecture

### Frontend (Mobile)
- Framework: Flutter/Dart
- State Management: BLoC pattern
- Local Storage: Hive
- API Client: Dio
- Testing: Flutter Test

### Backend
- Runtime: Node.js with Express
- Database: PostgreSQL
- Caching: Redis
- Authentication: JWT
- API Documentation: Swagger

## Testing

```bash
# Run backend tests
cd backend
npm test

# Run mobile tests
cd mobile
flutter test
```

## Deployment

### Mobile App
- CI/CD via GitHub Actions
- Automated builds for Android and iOS
- Distribution through Firebase App Distribution

### Backend
- Automated deployment to Heroku
- Database migrations
- Environment-specific configurations

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Team

- Project Lead: [Axel Medjber](https://github.com/axelmedjber)

## Support

For support, email monsdj.be@gmail.com or create an issue in the repository.

## Acknowledgments

- City of Mons for their support
- Local social grocery stores
- All contributors and supporters

---
Made with  in Mons, Belgium
