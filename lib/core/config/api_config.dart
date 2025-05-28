class ApiConfig {
  static const String googleSignInClientId = String.fromEnvironment(
    'GOOGLE_SIGN_IN_CLIENT_ID',
    defaultValue:
        '434782527915-9rsoql7m2631fjike6qi4slr3366dkom.apps.googleusercontent.com',
  );
}
