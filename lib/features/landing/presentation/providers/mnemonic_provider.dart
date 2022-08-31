import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/bip39.dart';
import 'package:polkadex/features/setup/domain/entities/imported_trade_account_entity.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_trade_account_usecase.dart';

class MnemonicProvider extends ChangeNotifier {
  MnemonicProvider({
    required GenerateMnemonicUseCase generateMnemonicUseCase,
    required ImportTradeAccountUseCase importAccountUseCase,
    int phraseLenght = 12,
  })  : _generateMnemonicUseCase = generateMnemonicUseCase,
        _importAccountUseCase = importAccountUseCase,
        mnemonicWords = List.generate(phraseLenght, (_) => '');

  final GenerateMnemonicUseCase _generateMnemonicUseCase;
  final ImportTradeAccountUseCase _importAccountUseCase;

  bool _disposed = false;
  bool _isLoading = false;
  bool _hasShuffledMnemonicChanged = false;
  int? indexWordEdited;
  List<String> mnemonicWords;
  late List<String> _shuffledMnemonicWords;
  final List<String> _suggestionsMnemonicWords = [];

  bool get isLoading => _isLoading;
  bool get hasShuffledMnemonicChanged => _hasShuffledMnemonicChanged;
  bool get isMnemonicComplete => !mnemonicWords.contains('');
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
    _shuffledMnemonicWords.shuffle();
  }

  void changeMnemonicWord(int index, String newWord) {
    bool isCompleteBefore = isMnemonicComplete;
    mnemonicWords[index] = newWord.trim();

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
    for (int i = 0; i < mnemonicWords.length; i++) {
      if (_shuffledMnemonicWords[i] != mnemonicWords[i]) {
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
      (mnemonic) => mnemonicWords = List.unmodifiable(
        [...mnemonic],
      ),
    );

    _shuffledMnemonicWords = [...mnemonicWords];

    _loading = false;
  }

  Future<ImportedTradeAccountEntity?> createImportedAccount() async {
    final result = await _importAccountUseCase(
      mnemonic: mnemonicWords.join(' '),
      password: '',
    );

    ImportedTradeAccountEntity? newAccount;

    result.fold(
      (_) => null,
      (importedTradeAccount) => newAccount = importedTradeAccount,
    );

    return newAccount;
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
