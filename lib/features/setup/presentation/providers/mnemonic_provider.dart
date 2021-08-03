import 'package:flutter/material.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';

class MnemonicProvider extends ChangeNotifier {
  MnemonicProvider({
    required GenerateMnemonicUseCase generateMnemonicUseCase,
    required ImportAccountUseCase importAccountUseCase,
  })  : _generateMnemonicUseCase = generateMnemonicUseCase,
        _importAccountUseCase = importAccountUseCase;

  final GenerateMnemonicUseCase _generateMnemonicUseCase;
  final ImportAccountUseCase _importAccountUseCase;

  bool _disposed = false;
  bool _isLoading = false;
  bool _isButtonToBackupEnabled = false;
  bool _isButtonBackupVerificationEnabled = false;
  List<String> _mnemonicWords = List.generate(12, (_) => '');
  late List<String> _shuffledMnemonicWords;

  bool get isLoading => _isLoading;
  bool get isButtonToBackupEnabled => _isButtonToBackupEnabled && !_isLoading;
  bool get isButtonBackupVerificationEnabled =>
      _isButtonBackupVerificationEnabled;
  bool get isMnemonicComplete => !_mnemonicWords.contains('');
  List<String> get mnemonicWords => _mnemonicWords;
  List<String> get shuffledMnemonicWords => _shuffledMnemonicWords;

  set _loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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

  void changeButtonToBackupState() {
    _isButtonToBackupEnabled = !_isButtonToBackupEnabled;
    notifyListeners();
  }

  void shuffleMnemonicWords() {
    _isButtonBackupVerificationEnabled = false;
    _shuffledMnemonicWords.shuffle();
  }

  void changeMnemonicWord(int index, String newWord) {
    bool isCompleteBefore = isMnemonicComplete;
    _mnemonicWords[index] = newWord.trim();

    if (isCompleteBefore != isMnemonicComplete) {
      notifyListeners();
    }
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

  void generateMnemonic() async {
    _loading = true;

    final result = await _generateMnemonicUseCase();

    result.fold(
      (l) => null,
      (mnemonic) => _mnemonicWords = List.unmodifiable(
        [...mnemonic],
      ),
    );

    _shuffledMnemonicWords = [..._mnemonicWords];

    _loading = false;
  }

  Future<bool> checkMnemonicValid() async {
    final result = await _importAccountUseCase(
      mnemonic: _mnemonicWords.join(' '),
      password: '',
    );

    return result.isRight();
  }

  Future<void> importAccount(String password) async {
    final result = await _importAccountUseCase(
      mnemonic: _mnemonicWords.join(' '),
      password: password,
    );

    result.fold(
      (_) {},
      (importedAcc) {
        //TODO: Use the imported in the app or store it
      },
    );
  }
}
