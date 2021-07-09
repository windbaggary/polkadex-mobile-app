import 'package:flutter/material.dart';

/// The provider to handle the card expansion of token and pair
/// in Market selection screen
class TokenPairExpandedProvider extends ChangeNotifier {
  bool _isExpanded = false;

  bool get isPairExpanded => !this._isExpanded;
  bool get isTokenExpanded => this._isExpanded;

  set isPairExpanded(bool val) {
    this._isExpanded = !val;
    notifyListeners();
  }

  set isTokenExpanded(bool val) {
    this._isExpanded = val;
    notifyListeners();
  }
}
