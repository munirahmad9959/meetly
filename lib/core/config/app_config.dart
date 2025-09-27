import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration utility class
/// Provides easy access to environment variables from .env file
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  /// App Configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'Meetly';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';

  /// API Configuration
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static int get apiTimeout =>
      int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  /// Firebase Web Configuration
  static String get firebaseWebApiKey =>
      dotenv.env['FIREBASE_WEB_API_KEY'] ?? '';
  static String get firebaseWebAppId => dotenv.env['FIREBASE_WEB_APP_ID'] ?? '';
  static String get firebaseWebMessagingSenderId =>
      dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseWebProjectId =>
      dotenv.env['FIREBASE_WEB_PROJECT_ID'] ?? '';
  static String get firebaseWebAuthDomain =>
      dotenv.env['FIREBASE_WEB_AUTH_DOMAIN'] ?? '';
  static String get firebaseWebStorageBucket =>
      dotenv.env['FIREBASE_WEB_STORAGE_BUCKET'] ?? '';

  /// Firebase Android Configuration
  static String get firebaseAndroidApiKey =>
      dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? '';
  static String get firebaseAndroidAppId =>
      dotenv.env['FIREBASE_ANDROID_APP_ID'] ?? '';
  static String get firebaseAndroidMessagingSenderId =>
      dotenv.env['FIREBASE_ANDROID_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseAndroidProjectId =>
      dotenv.env['FIREBASE_ANDROID_PROJECT_ID'] ?? '';
  static String get firebaseAndroidStorageBucket =>
      dotenv.env['FIREBASE_ANDROID_STORAGE_BUCKET'] ?? '';

  /// Firebase iOS Configuration
  static String get firebaseIosApiKey =>
      dotenv.env['FIREBASE_IOS_API_KEY'] ?? '';
  static String get firebaseIosAppId => dotenv.env['FIREBASE_IOS_APP_ID'] ?? '';
  static String get firebaseIosMessagingSenderId =>
      dotenv.env['FIREBASE_IOS_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseIosProjectId =>
      dotenv.env['FIREBASE_IOS_PROJECT_ID'] ?? '';
  static String get firebaseIosStorageBucket =>
      dotenv.env['FIREBASE_IOS_STORAGE_BUCKET'] ?? '';
  static String get firebaseIosBundleId =>
      dotenv.env['FIREBASE_IOS_BUNDLE_ID'] ?? '';

  /// Firebase macOS Configuration
  static String get firebaseMacosApiKey =>
      dotenv.env['FIREBASE_MACOS_API_KEY'] ?? '';
  static String get firebaseMacosAppId =>
      dotenv.env['FIREBASE_MACOS_APP_ID'] ?? '';
  static String get firebaseMacosMessagingSenderId =>
      dotenv.env['FIREBASE_MACOS_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseMacosProjectId =>
      dotenv.env['FIREBASE_MACOS_PROJECT_ID'] ?? '';
  static String get firebaseMacosStorageBucket =>
      dotenv.env['FIREBASE_MACOS_STORAGE_BUCKET'] ?? '';
  static String get firebaseMacosBundleId =>
      dotenv.env['FIREBASE_MACOS_BUNDLE_ID'] ?? '';

  /// Firebase Windows Configuration
  static String get firebaseWindowsApiKey =>
      dotenv.env['FIREBASE_WINDOWS_API_KEY'] ?? '';
  static String get firebaseWindowsAppId =>
      dotenv.env['FIREBASE_WINDOWS_APP_ID'] ?? '';
  static String get firebaseWindowsMessagingSenderId =>
      dotenv.env['FIREBASE_WINDOWS_MESSAGING_SENDER_ID'] ?? '';
  static String get firebaseWindowsProjectId =>
      dotenv.env['FIREBASE_WINDOWS_PROJECT_ID'] ?? '';
  static String get firebaseWindowsAuthDomain =>
      dotenv.env['FIREBASE_WINDOWS_AUTH_DOMAIN'] ?? '';
  static String get firebaseWindowsStorageBucket =>
      dotenv.env['FIREBASE_WINDOWS_STORAGE_BUCKET'] ?? '';

  /// Print all configuration (for debugging - only in development)
}
