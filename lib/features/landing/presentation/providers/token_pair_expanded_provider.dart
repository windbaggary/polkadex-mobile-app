import 'package:flutter/material.dart';

/// The provider to handle the card expansion of token and pair
/// in Market selection screen
class TokenPairExpandedProvider extends ChangeNotifier {
  bool _isExpanded = false;

  bool get isPairExpanded => !_isExpanded;
  bool get isTokenExpanded => _isExpanded;

  set isPairExpanded(bool val) {
    _isExpanded = !val;
    notifyListeners();
  }

  set isTokenExpanded(bool val) {
    _isExpanded = val;
    notifyListeners();
  }
}
