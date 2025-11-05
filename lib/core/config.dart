class AppConfig {
  static const String appName = 'Ngalah Mobile'; // nama aplikasi
  static const String baseUrl = String.fromEnvironment(
    // URL dasar API
    'BASE_URL',
    defaultValue: 'https://api.example.com',
  );
}
