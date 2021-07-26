import 'package:flutter/material.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';

class MnemonicProvider extends ChangeNotifier {
  MnemonicProvider({
    required GenerateMnemonicUseCase generateMnemonicUseCase,
  }) : _generateMnemonicUseCase = generateMnemonicUseCase;

  final GenerateMnemonicUseCase _generateMnemonicUseCase;

  bool _disposed = false;
  bool _isLoading = true;
  bool _isButtonToBackupEnabled = false;
  bool _isButtonBackupVerificationEnabled = false;
  late List<String> _mnemonicWords;
  late List<String> _shuffledMnemonicWords;

  bool get isLoading => _isLoading;
  bool get isButtonToBackupEnabled => _isButtonToBackupEnabled && !_isLoading;
  bool get isButtonBackupVerificationEnabled =>
      _isButtonBackupVerificationEnabled;
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

  void changeButtonToBackupState() {
    _isButtonToBackupEnabled = !_isButtonToBackupEnabled;
    notifyListeners();
  }

  void shuffleMnemonicWords() {
    _isButtonBackupVerificationEnabled = false;
    _shuffledMnemonicWords.shuffle();
  }

  void swapWordsFromShuffled(String firstWord, String secondWord) {
    _isButtonBackupVerificationEnabled = true;

    final int _indexFirst = _shuffledMnemonicWords.indexOf(firstWord);
    final int _indexSecond = _shuffledMnemonicWords.indexOf(secondWord);

    _shuffledMnemonicWords[_indexFirst] = secondWord;
    _shuffledMnemonicWords[_indexSecond] = firstWord;

    notifyListeners();
  }

  bool verifyMnemonicOrder() {
    for (int i = 0; i < _mnemonicWords.length; i++) {
      if (_shuffledMnemonicWords[i] != _mnemonicWords[i]) {
        _isButtonBackupVerificationEnabled = false;
        notifyListeners();

        return false;
      }
    }

    return true;
  }

  /// Make a 2 sec delay and toggle the isLoading to true
  void loadMnemonic() =>
      Future.delayed(const Duration(seconds: 2)).then((_) async {
        final result = await _generateMnemonicUseCase();

        result.fold(
          (l) => null,
          (mnemonic) => _mnemonicWords = List.unmodifiable(
            [...mnemonic],
          ),
        );

        _shuffledMnemonicWords = [..._mnemonicWords];

        _loading = false;
      });
}
