/// Email validation using a simple regex pattern
/// Validates basic email format without being overly strict
bool isValidEmail(String email) {
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

/// Password validation: minimum 6 characters
bool isValidPassword(String password) {
  return password.length >= 6;
}

/// Username validation: non-empty, at least 2 characters
bool isValidUsername(String username) {
  return username.trim().length >= 2;
}
