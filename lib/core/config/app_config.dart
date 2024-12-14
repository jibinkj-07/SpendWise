import 'dart:ui';

sealed class AppConfig {
  static final String _appName = "SpendWise";
  static final String _version = "1.1.0";
  static final String _fontFamily = "Poppins";
  static final String _slogan = "Spend Smarter, Live Better";
  static final Color _primaryColor = Color(0xFF00539F);
  static final Color _generalColor = Color(0xFF67BFFF);
  static final Color _focusColor = Color(0xFFFFA726);
  static final Color _secondaryColor = Color(0xFF00796B);
  static final Color _errorColor = Color(0xFFEE1C2E);

  static String get name => _appName;

  static String get version => _version;

  static String get slogan => _slogan;

  static String get fontFamily => _fontFamily;

  static Color get primaryColor => _primaryColor;

  static Color get secondaryColor => _secondaryColor;

  static Color get generalColor => _generalColor;

  static Color get focusColor => _focusColor;

  static Color get errorColor => _errorColor;
}
