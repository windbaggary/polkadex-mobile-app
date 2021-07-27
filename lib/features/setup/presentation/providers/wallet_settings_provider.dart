import 'package:flutter/material.dart';
import 'package:polkadex/features/setup/presentation/utils/password_regex.dart';

class WalletSettingsProvider extends ChangeNotifier {
  bool _isFingerPrintEnabled = false;
  bool _hasLeast8Characters = false;
  bool _hasLeast1Uppercase = false;
  bool _hasLeast1LowercaseLetter = false;
  bool _hasLeast1Digit = false;
  bool _isNextEnabled = false;

  bool get isFingerPrintEnabled => _isFingerPrintEnabled;
  bool get hasLeast8Characters => _hasLeast8Characters;
  bool get hasLeast1Uppercase => _hasLeast1Uppercase;
  bool get hasLeast1LowercaseLetter => _hasLeast1LowercaseLetter;
  bool get hasLeast1Digit => _hasLeast1Digit;
  bool get isNextEnabled => _isNextEnabled;

  set fingerPrintAuth(bool value) {
    _isFingerPrintEnabled = value;
    notifyListeners();
  }

  void _evalPasswordRequirements(String password) {
    _hasLeast8Characters = PasswordRegex.check8Characters(password);
    _hasLeast1Uppercase = PasswordRegex.check1Uppercase(password);
    _hasLeast1LowercaseLetter = PasswordRegex.check1Lowercase(password);
    _hasLeast1Digit = PasswordRegex.check1Digit(password);
  }

  void evalNextEnabled(String name, String password, String repeatPassword) {
    _evalPasswordRequirements(password);

    _isNextEnabled = _hasLeast8Characters &&
        _hasLeast1Uppercase &&
        _hasLeast1LowercaseLetter &&
        _hasLeast1Digit &&
        name.isNotEmpty &&
        (password == repeatPassword);

    notifyListeners();
  }
}
