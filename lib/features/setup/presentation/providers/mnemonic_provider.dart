import 'package:flutter/material.dart';

class MnemonicProvider extends ChangeNotifier {
  bool _disposed = false;
  bool _isLoading = true;
  bool _isNextEnabled = false;
  late List<String> _mnemonicWords;
  late List<String> _shuffledMnemonicWords;

  bool get isLoading => _isLoading;
  bool get isNextEnabled => _isNextEnabled && !_isLoading;
  List<String> get mnemonicWords => _mnemonicWords;
  List<String> get shuffledMnemonicWords => _shuffledMnemonicWords;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  set _loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void changeNextButtonState() {
    _isNextEnabled = !_isNextEnabled;
    notifyListeners();
  }

  void swapWordsFromShuffled(String firstWord, String secondWord) {
    final int _indexFirst = _shuffledMnemonicWords.indexOf(firstWord);
    final int _indexSecond = _shuffledMnemonicWords.indexOf(secondWord);

    _shuffledMnemonicWords[_indexFirst] = secondWord;
    _shuffledMnemonicWords[_indexSecond] = firstWord;

    notifyListeners();
  }

  /// Make a 2 sec delay and toggle the isLoading to true
  void initLoadingTimer() =>
      Future.delayed(const Duration(seconds: 2)).then((_) {
        _mnemonicWords = List.unmodifiable([
          'sickness',
          'present',
          'island',
          'bomb',
          'applied',
          'leftovers',
          'ideology',
          'center',
          'tropical',
          'motivation',
          'lily',
          'rice',
        ]);
        _shuffledMnemonicWords = [..._mnemonicWords]..shuffle();

        _loading = false;
      });
}
