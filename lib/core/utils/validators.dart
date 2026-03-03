class Validators {
  /// Required
  static String? required(String value, String fieldName) {
    if (value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  /// Email
  static String? email(String value) {
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!regex.hasMatch(value)) {
      return "Enter valid email";
    }
    return null;
  }

  /// Phone (11 digits)
  static String? phone(String value) {
    final regex = RegExp(r'^\d{11}$');

    if (!regex.hasMatch(value)) {
      return "Phone must be 11 digits";
    }
    return null;
  }

  /// ID number (numbers only)
  static String? idNumber(String value) {
    final regex = RegExp(r'^\d+$');

    if (!regex.hasMatch(value)) {
      return "ID must contain numbers only";
    }
    return null;
  }

  /// Password
  static String? password(String value) {
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  /// Confirm password
  static String? confirmPassword(String pass, String confirm) {
    if (pass != confirm) {
      return "Passwords do not match";
    }
    return null;
  }
}
