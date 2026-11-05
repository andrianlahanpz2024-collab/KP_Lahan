/// Utility class for form field validation in the app
class Validators {
  /// Validates the user's display name (required, min 2 chars, letters only)
  static String? validateName(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Name is required';
    }
    if (text.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r"^[\p{L}\s'\-]+$", unicode: true).hasMatch(text)) {
      return 'Name may only contain letters';
    }
    return null;
  }

  /// Validates the email address (required, valid regex format)
  static String? validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Enter your email address';
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(text)) {
      return 'Invalid email format (example: user@domain.com)';
    }
    return null;
  }

  /// Validates the password for sign-in
  static String? validateLoginPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Enter your password';
    }
    if (text.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates the password for registration
  static String? validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Enter your password';
    }
    if (text.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  /// Validates the password confirmation field
  static String? validateConfirmPassword(String? value, String password) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Confirm your password';
    }
    if (text != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validates the current password field
  static String? validateCurrentPassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Enter your current password';
    }
    return null;
  }

  /// Validates the new password (must differ from the current one)
  static String? validateNewPassword(String? value, String currentPassword) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Enter your new password';
    }
    if (text.length < 6) {
      return 'New password must be at least 6 characters';
    }
    if (text == currentPassword) {
      return 'New password must differ from current password';
    }
    return null;
  }

  /// Validates the profile photo URL (optional, but must be a valid HTTP/HTTPS URL)
  static String? validateAvatarUrl(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(text);
    if (uri == null || (!uri.isScheme('http') && !uri.isScheme('https')) || uri.host.isEmpty) {
      return 'Enter a valid HTTPS/HTTP image URL';
    }
    return null;
  }
}
