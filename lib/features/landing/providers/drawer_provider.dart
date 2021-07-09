// import 'dart:async';

// import 'package:flutter/material.dart';

// /// The provider to handle the drawer position
// ///
// class AppDrawerProvider extends ChangeNotifier {
//   final VoidCallback onDrawerOpen;
//   final VoidCallback onDrawerClose;
//   bool _isVisible = false;

//   AppDrawerProvider({
//     this.onDrawerOpen,
//     this.onDrawerClose,
//   }) : super();

//   /// Returns if the drawer is visible
//   bool get isVisible => this._isVisible;

//   /// Set true to visible the drawer and the notify will be called
//   set _setIsVisible(bool value) {
//     this._isVisible = value;
//     notifyListeners();
//   }

//   /// If the drawer is visible it will and if the drawer is closed it will open
//   void toggleDrawer() {
//     this._setIsVisible = !this._isVisible;
//   }

//   /// Shows the drawer menu on invoke
//   void openDrawer() {
//     this._setIsVisible = true;
//   }

//   /// Hide the drawer menu on invoke
//   void hideDrawer() {
//     this._setIsVisible = false;
//   }
// }
