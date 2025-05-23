# Apartmaint

A cross-platform property management application for apartment maintenance with role-based access control.

## Features

- **Multi-role Support**: Landlord, Handyman, and Tenant roles with different access levels
- **Property Management**: Manage multiple properties and units
- **Maintenance Requests**: Submit and track maintenance problems
- **Real-time Notifications**: Firebase Cloud Messaging integration
- **Payment Processing**: Stripe integration for rental payments
- **Employee Management**: Manage handyman staff and timesheets
- **Chat System**: In-app messaging between users
- **Document Management**: Upload and share property-related documents

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod
- **Backend**: Firebase (Auth, Firestore, Storage, Functions)
- **Navigation**: Go Router
- **Payments**: Stripe
- **Architecture**: Clean Architecture with feature-based structure

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Firebase project setup
- Stripe account (for payments)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/NoCool14/apartmaint.git
cd apartmaint
```

2. Install dependencies:
```bash
flutter pub get
```

3. Set up Firebase:
   - Create a Firebase project
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Configure Firebase Authentication, Firestore, and Storage

4. Create a `.env` file with your configuration:
```env
APP_NAME=Apartmaint
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key
```

5. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── app/                    # App-level configuration
│   ├── config/            # Firebase and app configuration
│   └── navigation/        # Routing configuration
├── core/                  # Core utilities and services
│   ├── extensions/        # Dart extensions
│   ├── services/          # Global services
│   └── utils/            # Utility functions
└── features/             # Feature modules
    ├── auth/             # Authentication
    ├── dashboard/        # Dashboard screens
    ├── properties/       # Property management
    ├── problems/         # Maintenance requests
    ├── payments/         # Payment processing
    ├── notifications/    # Push notifications
    └── employees/        # Staff management
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
