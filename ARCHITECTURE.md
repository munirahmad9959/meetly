# Clean Architecture - Feature-Based Directory Structure

## 📁 Project Structure

```
lib/
├── core/
│   ├── routes/
│   │   └── app_routes.dart
│   └── service_locator.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_data_source.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── get_auth_state_usecase.dart
│   │   │       ├── get_current_user_usecase.dart
│   │   │       ├── reset_password_usecase.dart
│   │   │       ├── sign_in_usecase.dart
│   │   │       ├── sign_out_usecase.dart
│   │   │       └── sign_up_usecase.dart
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   └── register_page.dart
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       └── widgets/
│   │           ├── custom_button.dart
│   │           └── custom_text_field.dart
│   ├── home/
│   │   └── presentation/
│   │       └── pages/
│   │           └── home_page.dart
│   ├── settings/
│   │   └── presentation/
│   │       └── pages/
│   │           └── settings_page.dart
│   └── splash/
│       └── presentation/
│           └── pages/
│               └── splash_page.dart
├── shared/
│   └── widgets/
│       └── auth_wrapper.dart
├── firebase_options.dart
└── main.dart
```

## 🏗️ Architecture Overview

### **Core Layer**
- **Routes**: Centralized route management
- **Service Locator**: Dependency injection container

### **Features Layer**
Each feature follows Clean Architecture:

#### **Data Layer**
- **DataSources**: External data sources (Firebase, API, etc.)
- **Models**: Data transfer objects with conversion logic
- **Repositories**: Implementation of domain repository interfaces

#### **Domain Layer** (Business Logic)
- **Entities**: Core business objects
- **Repositories**: Abstract interfaces
- **Use Cases**: Single responsibility business logic operations

#### **Presentation Layer**
- **Pages**: UI screens
- **Providers**: State management with Provider pattern
- **Widgets**: Reusable UI components

### **Shared Layer**
- Common widgets and utilities used across features

## 🔄 Data Flow

1. **UI** triggers action (login button pressed)
2. **Provider** calls appropriate use case
3. **Use Case** validates input and calls repository
4. **Repository** calls data source (Firebase Auth)
5. **Data Source** performs actual operation
6. **Result** flows back up through layers
7. **Provider** updates UI state
8. **UI** rebuilds with new state

## 🚀 Benefits

✅ **Separation of Concerns**: Each layer has single responsibility
✅ **Testability**: Business logic isolated and easily testable
✅ **Maintainability**: Changes in one layer don't affect others
✅ **Scalability**: Easy to add new features following same pattern
✅ **Independence**: Domain layer independent of frameworks
✅ **SOLID Principles**: Follows all SOLID design principles

## 🔧 How to Add New Features

1. Create feature directory: `lib/features/new_feature/`
2. Add domain layer: entities, repositories, use cases
3. Add data layer: models, data sources, repository implementations
4. Add presentation layer: pages, providers, widgets
5. Register dependencies in service locator
6. Add routes if needed

## 🎯 Key Improvements from Old Structure

- **Feature-based** instead of layer-based organization
- **Clean separation** of business logic from UI and data
- **Dependency injection** for better testability
- **Provider pattern** with Clean Architecture principles
- **Centralized** dependency management
- **Scalable** structure for adding new features

This structure ensures your app is maintainable, testable, and follows industry best practices!