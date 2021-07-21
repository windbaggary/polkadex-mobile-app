import 'package:flutter/material.dart';

class MnemonicGeneratedProvider extends ChangeNotifier {
  bool _isLoading = true;
  final List<String> _mnemonicWords = [];

  bool get isLoading => _isLoading;
  List<String> get mnemonicWords => _mnemonicWords;

  set _loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Make a 2 sec delay and toggle the isLoading to true
  void initLoadingTimer() =>
      Future.delayed(const Duration(seconds: 2)).then((_) => _loading = false);
}
