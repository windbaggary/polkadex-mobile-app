import 'package:flutter/material.dart';

/// The provider to handle the image selection and displays
class MyAccountProfileProvider extends ChangeNotifier {
  /// The local image path
  final String _imgFilePath = "";

  bool get hasImg => _imgFilePath.isNotEmpty;

  String get imgFile => _imgFilePath;
}

/// The provider to handle the edit texts on profile
class MyAccountEditNameProvider extends ChangeNotifier {
  String _name = "kas Pintxuki";
  final TextEditingController controller =
      TextEditingController(text: 'Kas Pintxuki');
  bool _isNameEditOn = false;

  bool get canEditName => _isNameEditOn;

  String get name => _name;

  /// Set to true to enable the save button and textfield
  set canEditName(bool value) {
    _isNameEditOn = value;
    if (value) {
      controller.text = _name;
    }
    notifyListeners();
  }

  /// The method will be invoked when the user clicks on save
  void onSave() {
    _name = controller.text;
    _isNameEditOn = false;
    notifyListeners();
  }
}
