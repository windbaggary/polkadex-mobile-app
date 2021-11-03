import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/bip39.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';

class MnemonicProvider extends ChangeNotifier {
  MnemonicProvider({
    required GenerateMnemonicUseCase generateMnemonicUseCase,
    required ImportAccountUseCase importAccountUseCase,
    int phraseLenght = 12,
  })  : _generateMnemonicUseCase = generateMnemonicUseCase,
        _importAccountUseCase = importAccountUseCase,
        _mnemonicWords = List.generate(phraseLenght, (_) => '');

  final GenerateMnemonicUseCase _generateMnemonicUseCase;
  final ImportAccountUseCase _importAccountUseCase;

  bool _disposed = false;
  bool _isLoading = false;
  bool _hasShuffledMnemonicChanged = false;
  int? indexWordEdited;
  List<String> _mnemonicWords;
  late List<String> _shuffledMnemonicWords;
  final List<String> _suggestionsMnemonicWords = [];

  bool get isLoading => _isLoading;
  bool get hasShuffledMnemonicChanged => _hasShuffledMnemonicChanged;
  bool get isMnemonicComplete => !_mnemonicWords.contains('');
  List<String> get mnemonicWords => _mnemonicWords;
  List<String> get shuffledMnemonicWords => _shuffledMnemonicWords;
  List<String> get suggestionsMnemonicWords => _suggestionsMnemonicWords;

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

  void shuffleMnemonicWords() {
    _hasShuffledMnemonicChanged = false;
    //_shuffledMnemonicWords.shuffle();
  }

  void changeMnemonicWord(int index, String newWord) {
    bool isCompleteBefore = isMnemonicComplete;
    _mnemonicWords[index] = newWord.trim();

    if (isCompleteBefore != isMnemonicComplete) {
      notifyListeners();
    }
  }

  void swapWordsFromShuffled(String firstWord, String secondWord) {
    _hasShuffledMnemonicChanged = true;

    final int _indexFirst = _shuffledMnemonicWords.indexOf(firstWord);
    final int _indexSecond = _shuffledMnemonicWords.indexOf(secondWord);

    _shuffledMnemonicWords[_indexFirst] = secondWord;
    _shuffledMnemonicWords[_indexSecond] = firstWord;

    notifyListeners();
  }

  bool verifyMnemonicOrder() {
    for (int i = 0; i < _mnemonicWords.length; i++) {
      if (_shuffledMnemonicWords[i] != _mnemonicWords[i]) {
        _hasShuffledMnemonicChanged = false;
        notifyListeners();

        return false;
      }
    }

    return true;
  }

  Future<void> generateMnemonic() async {
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

  Future<void> searchSuggestions(String inputWord) async {
    _suggestionsMnemonicWords.clear();

    for (int i = 0;
        i < wordList.length && _suggestionsMnemonicWords.length < 5;
        i++) {
      if (wordList[i].startsWith(inputWord)) {
        _suggestionsMnemonicWords.add(wordList[i]);
      }
    }

    notifyListeners();
  }

  Future<void> clearSuggestions() async {
    _suggestionsMnemonicWords.clear();
    indexWordEdited = null;

    notifyListeners();
  }
}
