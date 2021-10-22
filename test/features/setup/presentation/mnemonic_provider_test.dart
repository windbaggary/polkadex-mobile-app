import 'package:polkadex/common/utils/bip39.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';

class _MockGenerateUsecase extends Mock implements GenerateMnemonicUseCase {}

class _MockImportUsecase extends Mock implements ImportAccountUseCase {}

void main() {
  late _MockGenerateUsecase _mockGenerateUsecase;
  late _MockImportUsecase _mockImportUsecase;
  late MnemonicProvider _mnemonicProvider;
  late String tMnemonic;
  late String tMnemonicSwapped;

  setUp(() {
    _mockGenerateUsecase = _MockGenerateUsecase();
    _mockImportUsecase = _MockImportUsecase();
    _mnemonicProvider = MnemonicProvider(
      generateMnemonicUseCase: _mockGenerateUsecase,
      importAccountUseCase: _mockImportUsecase,
    );
    tMnemonic = "correct gather fork";
    tMnemonicSwapped = "gather correct fork";
    //tMeta = MetaModel(name: 'userName');
    //tEncoding = EncodingModel(
    //  content: ["sr25519"],
    //  version: '3',
    //  type: ["none"],
    //);
    //tImportedAccount = ImportedAccountModel(
    //  encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
    //  encoding: tEncoding,
    //  address: "k9o1dxJxQE8Zwm5Fy",
    //  meta: tMeta,
    //);
  });

  group(
    'MnemonicProvider provider test',
    () {
      test(
        'mnemonic generation success',
        () async {
          // arrange
          when(() => _mockGenerateUsecase()).thenAnswer(
            (_) async => Right(tMnemonic.split(' ')),
          );
          // act
          await _mnemonicProvider.generateMnemonic();
          // assert

          expect(_mnemonicProvider.mnemonicWords, tMnemonic.split(' '));
          expect(
              _mnemonicProvider.mnemonicWords ==
                  _mnemonicProvider.shuffledMnemonicWords,
              false);
          verify(() => _mockGenerateUsecase()).called(1);
          verifyNoMoreInteractions(_mockGenerateUsecase);
        },
      );

      test(
        'swap shuffled word from mnemonic',
        () async {
          // arrange
          when(() => _mockGenerateUsecase()).thenAnswer(
            (_) async => Right(tMnemonic.split(' ')),
          );
          // act
          await _mnemonicProvider.generateMnemonic();
          final firstWord = _mnemonicProvider.shuffledMnemonicWords[0];
          final secondWord = _mnemonicProvider.shuffledMnemonicWords[1];
          _mnemonicProvider.swapWordsFromShuffled('correct', 'gather');
          // assert

          expect(firstWord, _mnemonicProvider.shuffledMnemonicWords[1]);
          expect(secondWord, _mnemonicProvider.shuffledMnemonicWords[0]);
          verify(() => _mockGenerateUsecase()).called(1);
          verifyNoMoreInteractions(_mockGenerateUsecase);
        },
      );

      test(
        'mnemonic order verification success',
        () async {
          // arrange
          when(() => _mockGenerateUsecase()).thenAnswer(
            (_) async => Right(tMnemonic.split(' ')),
          );
          // act
          await _mnemonicProvider.generateMnemonic();
          _mnemonicProvider.shuffledMnemonicWords
            ..clear()
            ..addAll(tMnemonic.split(' '));
          final result = _mnemonicProvider.verifyMnemonicOrder();
          // assert

          expect(result, true);
          verify(() => _mockGenerateUsecase()).called(1);
          verifyNoMoreInteractions(_mockGenerateUsecase);
        },
      );

      test(
        'mnemonic order verification fail',
        () async {
          // arrange
          when(() => _mockGenerateUsecase()).thenAnswer(
            (_) async => Right(tMnemonic.split(' ')),
          );
          // act
          await _mnemonicProvider.generateMnemonic();
          _mnemonicProvider.shuffledMnemonicWords
            ..clear()
            ..addAll(tMnemonicSwapped.split(' '));
          final result = _mnemonicProvider.verifyMnemonicOrder();
          // assert

          expect(result, false);
          verify(() => _mockGenerateUsecase()).called(1);
          verifyNoMoreInteractions(_mockGenerateUsecase);
        },
      );

      test(
        'fill suggestions for mnemonic word on import account',
        () async {
          // act
          await _mnemonicProvider.searchSuggestions('a');
          // assert

          final wordsAreSuggestions = _mnemonicProvider.suggestionsMnemonicWords
              .every((word) => wordList.contains(word));

          expect(wordsAreSuggestions, true);
          expect(_mnemonicProvider.suggestionsMnemonicWords.length, 5);
        },
      );

      test(
        'clear suggestions for mnemonic word on import account',
        () async {
          // act
          await _mnemonicProvider.searchSuggestions('a');
          await _mnemonicProvider.clearSuggestions();
          // assert

          expect(_mnemonicProvider.suggestionsMnemonicWords.length, 0);
        },
      );

      //test(
      //  'import account success',
      //  () async {
      //    // arrange
      //    when(() => _mockImportUsecase(
      //        mnemonic: any(named: "mnemonic"),
      //        password: any(named: "password"))).thenAnswer(
      //      (_) async => Right(tImportedAccount),
      //    );
      //    // act
      //    _mnemonicProvider.changeMnemonicWord(0, 'correct');
      //    _mnemonicProvider.changeMnemonicWord(1, 'gather');
      //    _mnemonicProvider.changeMnemonicWord(2, 'fork');
      //    final resultCheck = await _mnemonicProvider.checkMnemonicValid();
      //    await _mnemonicProvider.importAccount('passwordTest', false);
      //    // assert
//
      //    expect(resultCheck, true);
      //    verify(() => _mockImportUsecase(
      //        mnemonic: any(named: "mnemonic"),
      //        password: any(named: "password"))).called(2);
      //    verifyNoMoreInteractions(_mockImportUsecase);
      //  },
      //);
//
      //test(
      //  'import account fail',
      //  () async {
      //    // arrange
      //    when(() => _mockImportUsecase(
      //        mnemonic: any(named: "mnemonic"),
      //        password: any(named: "password"))).thenAnswer(
      //      (_) async => Left(ApiError()),
      //    );
      //    // act
      //    final resultCheck = await _mnemonicProvider.checkMnemonicValid();
      //    await _mnemonicProvider('passwordTest', false);
      //    // assert
//
      //    expect(resultCheck, false);
      //    verify(() => _mockImportUsecase(
      //        mnemonic: any(named: "mnemonic"),
      //        password: any(named: "password"))).called(2);
      //    verifyNoMoreInteractions(_mockImportUsecase);
      //  },
      //);
    },
  );
}
