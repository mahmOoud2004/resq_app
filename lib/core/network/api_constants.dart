class ApiConstants {
  static const String baseUrl =
      "https://feelinglessly-preocular-xochitl.ngrok-free.dev/api";
  static const String storageBaseUrl =
      "https://feelinglessly-preocular-xochitl.ngrok-free.dev/storage/";

  static const String login = "/login";
  static const String register = "/register";
  static const String verifyOtp = "/verify-otp";
  static const String forgotPassword = "/forgot-password";
  static const String verifyResetOtp = "/verify-reset-otp";
  static const String resetPassword = "/reset-password";

  static const String profile = "/profile";
  static const String logout = "/logout";
  static const String updateUser = "/update-user";

  static const String createEmergency = "/emergency/create";

  static const String adminStats = "/admin/stats";
  static const String pendingUsers = "/admin/pending-users";
  static const String approveUser = "/admin/approve-user";
  static const String blockUser = "/admin/block-user";
  static const String activeEmergencies = "/admin/active-emergencies";
  static const String cancelEmergency = "/admin/cancel-emergency";

  static const String getActiveRequest = "/emergency/active";

  static const String googleMapsApiKeyEnv = "GOOGLE_MAPS_API_KEY";
}
