import 'dart:async';

import 'package:flutter/material.dart';
import 'package:polkadex/utils/enums.dart';

/// The provider to manage the functionality of the bnottom navigation widget
///
/// Click event and listener for the selection
class BottomNavigationProvider extends ChangeNotifier {
  final _streamController = StreamController<EnumBottonBarItem>.broadcast();
  static final BottomNavigationProvider _instance =
      BottomNavigationProvider._initialise();

  BottomNavigationProvider._initialise() : super();

  factory BottomNavigationProvider() => _instance;

  EnumBottonBarItem _enumBottonBarItem = EnumBottonBarItem.home;

  EnumBottonBarItem get enumBottomBarItem => _enumBottonBarItem;

  Stream<EnumBottonBarItem> get streamBottomBarItem => _streamController.stream;

  set enumBottomBarItem(EnumBottonBarItem val) {
    _enumBottonBarItem = val;
    _streamController.add(val);
    notifyListeners();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
