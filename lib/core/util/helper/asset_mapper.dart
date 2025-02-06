sealed class AssetMapper {
  /// ---------------------- LOTTIE FILES -------------------------

  static const String noInternetLottie = "assets/animations/no-internet.json";

  /// ---------------------- IMAGE FILES -------------------------
  static const String appIconImage = "assets/images/logo-01.png";
  static const String appIcon2Image = "assets/images/logo-02.png";

  static String getProfileImage(String name) => "assets/images/$name.jpg";

  /// ---------------------- SVG FILES -------------------------
  static const String googleSVG = "assets/svg/google.svg";
  static const String coinsSVG = "assets/svg/coins.svg";
  static const String emptySVG = "assets/svg/empty.svg";
  static const String inviteSVG = "assets/svg/invite.svg";
  static const String uploadSVG = "assets/svg/upload.svg";
  static const String errorSVG = "assets/svg/error.svg";
  static const String requestSVG = "assets/svg/request.svg";
  static const String pendingSVG = "assets/svg/pending.svg";
  static const String accessRevokedSVG = "assets/svg/access-revoked.svg";
  static const String warningSVG = "assets/svg/warning.svg";
  static const String completedSVG = "assets/svg/completed.svg";
}
