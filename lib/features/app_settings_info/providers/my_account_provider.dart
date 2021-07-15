import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// The provider to handle the image selection and displays
class MyAccountProfileProvider extends ChangeNotifier {
  /// The local image path
  String _imgFilePath = "";

  bool get hasImg => this._imgFilePath.isNotEmpty;

  String get imgFile => this._imgFilePath;

  /// Pick the image from system
  void pickImgFile() async {
    try {
      final file = await ImagePicker().getImage(
        source: ImageSource.gallery,
      );
      if (file != null) {
        this._imgFilePath = file.path;
        notifyListeners();
      }
    } catch (ex) {
      print(ex);
    }
  }
}

/// The provider to handle the edit texts on profile
class MyAccountEditNameProvider extends ChangeNotifier {
  String _name = "kas Pintxuki";
  final TextEditingController controller =
      TextEditingController(text: 'Kas Pintxuki');
  bool _isNameEditOn = false;

  bool get canEditName => this._isNameEditOn;

  String get name => this._name;

  /// Set to true to enable the save button and textfield
  set canEditName(bool value) {
    this._isNameEditOn = value;
    if (value) {
      controller.text = _name;
    }
    notifyListeners();
  }

  /// The method will be invoked when the user clicks on save
  void onSave() {
    _name = controller.text;
    this._isNameEditOn = false;
    notifyListeners();
  }
}
