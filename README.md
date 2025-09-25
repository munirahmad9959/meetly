# 📅 Meetly - Meeting Room Booking System

A Flutter-based role-based meeting room booking and scheduling system with Firebase authentication, designed for corporate environments to efficiently manage meeting rooms and user permissions.

## 🚀 Overview

Meetly is a lightweight corporate meeting scheduler app that enables organizations to manage users with different roles and efficiently schedule meetings in available rooms with capacity-based booking and priority management.

## 🔑 Core Purpose

* **User Management** - Manage users with roles like Manager, HR, Software Engineer, Sales Engineer
* **Meeting Scheduling** - Schedule and prioritize meetings in available rooms with capacity
* **Role-Based Access Control** - Different powers for Admin vs Normal Users

## 👨‍💼 User Types & Permissions

### **🔐 Admin Users**
- Full CRUD operations for user management
- Priority meeting scheduling (gets first slot preference)
- Complete system overview and control
- Can manage room availability and capacity

### **👤 Normal Users**
**Roles:** Manager, HR, Software Engineer, Sales Engineer
- Arrange meetings in available rooms
- View available time slots
- See their scheduled meetings
- Access personal meeting dashboard

## 📱 App Features

### 🔐 **Authentication System**
- **Login Screen** - Secure Firebase authentication for admin and users
- **Register Screen** - User registration with role assignment
- **Role-based routing** - Automatic redirection based on user type

### 🏠 **Dashboard (Home Screen)**
- User statistics and meeting analytics
- Quick meeting overview
- Personal meeting schedule
- Room availability at a glance

### 📊 **Meeting Management**
- **Software Engineers** - Can arrange meetings in available rooms
- **Admin Priority** - Priority assignment for admin-scheduled meetings
- **Personal Meetings** - Users can view their meetings on home tab
- **Real-time updates** - Live meeting status and room availability

### 📝 **Forms & Booking**
- Intuitive meeting arrangement forms
- Room selection with capacity display
- Time slot picker with availability check
- Meeting details and attendee management

### 📅 **Overview Tab**
- Monthly calendar view of all meetings
- Room occupancy visualization
- Meeting conflict detection
- Schedule optimization suggestions

### 🏢 **Room Management**
- Rooms with defined capacity limits
- Available time slots for scheduling
- Room booking conflict prevention
- Capacity-based meeting arrangement

## 🛠️ Technology Stack

- **Framework:** Flutter (Cross-platform mobile app)
- **Backend:** Firebase (Authentication, Firestore, Cloud Functions)
- **State Management:** [To be implemented - Provider/Bloc/Riverpod]
- **Database:** Firestore (NoSQL document database)
- **Authentication:** Firebase Auth
- **Platform:** Android & iOS

## 🔥 Firebase Integration

### Authentication Features
- Email/Password authentication
- Role-based user registration
- Secure login/logout functionality
- User session management
- Password reset capabilities

### Firestore Database Structure
```
users/
  ├── userId/
      ├── email: string
      ├── role: string (admin, manager, hr, software_engineer, sales_engineer)
      ├── name: string
      ├── createdAt: timestamp
      └── isActive: boolean

meetings/
  ├── meetingId/
      ├── title: string
      ├── description: string
      ├── organizer: userId
      ├── attendees: array
      ├── roomId: string
      ├── startTime: timestamp
      ├── endTime: timestamp
      ├── priority: number (admin meetings get higher priority)
      └── status: string

rooms/
  ├── roomId/
      ├── name: string
      ├── capacity: number
      ├── location: string
      ├── amenities: array
      └── isActive: boolean
```

## 🏗️ Project Structure

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── utils/
│   └── theme/
├── models/
│   ├── user_model.dart
│   ├── meeting_model.dart
│   └── room_model.dart
├── services/
│   ├── auth_service.dart
│   ├── firestore_service.dart
│   └── meeting_service.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   ├── dashboard/
│   │   └── home_screen.dart
│   ├── meetings/
│   │   ├── meeting_list_screen.dart
│   │   ├── create_meeting_screen.dart
│   │   └── meeting_detail_screen.dart
│   ├── rooms/
│   │   └── room_list_screen.dart
│   └── admin/
│       └── user_management_screen.dart
├── widgets/
│   ├── common/
│   ├── auth/
│   └── meetings/
└── providers/ (or blocs/)
    ├── auth_provider.dart
    ├── meeting_provider.dart
    └── room_provider.dart
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- Firebase account
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/meetly.git
   cd meetly
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project
   - Enable Authentication (Email/Password)
   - Create Firestore database
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place config files in respective platform directories

4. **Configure Firebase**
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools
   
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Firebase
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  
  # State Management
  provider: ^6.1.1  # or bloc, riverpod
  
  # UI/UX
  cupertino_icons: ^1.0.2
  google_fonts: ^6.1.0
  
  # Utilities
  intl: ^0.18.1
  uuid: ^4.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🎯 Current Development Phase

### ✅ Phase 1: Foundation (Current Focus)
- [x] Project setup and README documentation
- [ ] Firebase configuration and integration
- [ ] Basic authentication system (Login/Register)
- [ ] User model and role management
- [ ] Basic UI/UX design system

### 🔄 Phase 2: Core Features (Next)
- [ ] Dashboard implementation
- [ ] Meeting creation and management
- [ ] Room booking system
- [ ] User role-based access control

### 📋 Phase 3: Advanced Features (Future)
- [ ] Priority meeting scheduling
- [ ] Calendar integration
- [ ] Push notifications
- [ ] Advanced admin controls
- [ ] Meeting analytics and reporting

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Project Lead:** [Your Name]
- **Development:** [Team Members]

## 📞 Support

For support and questions, please open an issue in the GitHub repository or contact [your-email@example.com].

---

**Note:** This app is currently in active development. Features and documentation will be updated as development progresses.

## 🔄 Recent Updates

- **v0.1.0** - Initial project setup and README documentation
- **Next:** Firebase authentication integration and basic UI implementation