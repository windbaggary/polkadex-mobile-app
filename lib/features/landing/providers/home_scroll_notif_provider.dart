import 'package:flutter/material.dart';
import 'dart:math' as math;

/// The provider for hiding and visible appbar and bottom navigation bar inside
/// the home view
class HomeScrollNotifProvider extends ChangeNotifier {
  final double _appbarSize = kToolbarHeight;
  final double _bottomSize = 64;

  double get bottombarSize => _bottomSize;

  double _scrollOffset = 0.0;

  // double get scrollOffset => this._scrollOffset;

  set scrollOffset(double val) {
    _scrollOffset = val;
    notifyListeners();
  }

  double get minScrollPerc =>
      (_scrollOffset / math.max(_appbarSize, _bottomSize))
          .clamp(0.0, 1.0)
          .abs();

  double get appbarValue => minScrollPerc * _appbarSize;

  double get bottombarValue => minScrollPerc * _bottomSize;
}
