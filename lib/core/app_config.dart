class AppConfig {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const appName = 'BAJ-NEMO';
  static const tagline = 'Trouver rapidement un service';
}
