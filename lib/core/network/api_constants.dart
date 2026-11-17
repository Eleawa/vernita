class ApiEndPoints {
  // Default: 'http://localhost:8080' + run `adb reverse tcp:8080 tcp:8080`
  // (phone connected by USB). It does not depend on Wi-Fi or the firewall.
  //
  // Other cases (no code change needed, pass it when running):
  //   flutter run --dart-define=API_BASE_URL=http://<PC-IPv4>:8080   (Wi-Fi)
  //   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080    (emulator)
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  static const String signUp = '/api/v1/auth/register';
  static const String login = '/api/v1/auth/login';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String currentUser = '/api/v1/users/me';
}
