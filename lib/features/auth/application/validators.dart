/// Validates email address format.
///
/// Uses a simple regex pattern that checks for:
/// - Local part with alphanumeric and common special characters
/// - @ symbol
/// - Domain with at least one dot
/// - TLD with minimum 2 characters
///
/// Not overly strict to avoid rejecting valid international email formats.
///
/// Returns true if email format is valid, false otherwise.
bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

/// Validates password meets minimum requirements.
///
/// Firebase Auth requires minimum 6 characters.
/// Returns true if password has at least 6 characters.
bool isValidPassword(String password) {
  return password.length >= 6;
}

/// Validates username meets minimum requirements.
///
/// Requires:
/// - Non-empty after trimming whitespace
/// - At least 2 characters in length
///
/// Returns true if username is valid.
bool isValidUsername(String username) {
  return username.trim().length >= 2;
}
