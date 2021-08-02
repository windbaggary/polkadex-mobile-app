abstract class PasswordRegex {
  static bool check8Characters(String password) {
    RegExp least8CharRegex = RegExp(r'^.{8,}$');
    return least8CharRegex.hasMatch(password);
  }

  static bool check1Lowercase(String password) {
    RegExp lowercaseRegex = RegExp(r'^(?=.*[a-z]).*$');
    return lowercaseRegex.hasMatch(password);
  }

  static bool check1Uppercase(String password) {
    RegExp uppercaseRegex = RegExp(r'^(?=.*[A-Z]).*$');
    return uppercaseRegex.hasMatch(password);
  }

  static bool check1Digit(String password) {
    RegExp digitRegex = RegExp(r'^(?=.*?[0-9]).*$');
    return digitRegex.hasMatch(password);
  }
}
