class AppConfig {
  static const String appName = 'Ngalah Mobile';
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://api.example.com', // ganti di build arg
  );
}
