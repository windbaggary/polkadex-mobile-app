abstract class EmailRegex {
  static bool checkIsEmail(String email) {
    RegExp least8CharRegex = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return least8CharRegex.hasMatch(email);
  }
}
