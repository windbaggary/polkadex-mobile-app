import 'package:flutter/material.dart';

/// The dummy loading provider for the exchange tab in homescreen to show
/// the skelton login
class ExchangeLoadingProvider extends ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Make a 2 sec delay and toggle the isLoading to true
  void initLoadingTimer() =>
      Future.delayed(const Duration(seconds: 2)).then((_) => isLoading = false);
}
