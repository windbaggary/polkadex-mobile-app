import 'package:polkadex/common/utils/bip39.dart';
import 'package:test/test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';

class _MockGenerateUsecase extends Mock implements GenerateMnemonicUseCase {}

class _MockImportUsecase extends Mock implements ImportAccountUseCase {}

void main() {
  late _MockGenerateUsecase _mockGenerateUsecase;
  late _MockImportUsecase _mockImportUsecase;
  late MnemonicProvider _provider;
  late String tMnemonic;
  late String tMnemonicSwapped;
  late MetaEntity tMeta;
  late EncodingEntity tEncoding;
  late ImportedAccountEntity tImportedAccount;

  setUp(() {
    _mockGenerateUsecase = _MockGenerateUsecase();
    _mockImportUsecase = _MockImportUsecase();
    _provider = MnemonicProvider(
      generateMnemonicUseCase: _mockGenerateUsecase,
      importAccountUseCase: _mockImportUsecase,
    );
    tMnemonic = "correct gather fork";
    tMnemonicSwapped = "gather correct fork";
    tMeta = MetaModel(name: 'userName');
    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );
    tImportedAccount = ImportedAccountModel(
      pubKey: "0xe5639b03f86257d187b00b667ae58",
      mnemonic: tMnemonic,
      rawSeed: "",
      encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      encoding: tEncoding,
      address: "k9o1dxJxQE8Zwm5Fy",
      meta: tMeta,
    );
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
          await _provider.generateMnemonic();
          // assert

          expect(_provider.mnemonicWords, tMnemonic.split(' '));
          expect(_provider.mnemonicWords == _provider.shuffledMnemonicWords,
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
          await _provider.generateMnemonic();
          final firstWord = _provider.shuffledMnemonicWords[0];
          final secondWord = _provider.shuffledMnemonicWords[1];
          _provider.swapWordsFromShuffled('correct', 'gather');
          // assert

          expect(firstWord, _provider.shuffledMnemonicWords[1]);
          expect(secondWord, _provider.shuffledMnemonicWords[0]);
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
          await _provider.generateMnemonic();
          _provider.shuffledMnemonicWords
            ..clear()
            ..addAll(tMnemonic.split(' '));
          final result = _provider.verifyMnemonicOrder();
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
          await _provider.generateMnemonic();
          _provider.shuffledMnemonicWords
            ..clear()
            ..addAll(tMnemonicSwapped.split(' '));
          final result = _provider.verifyMnemonicOrder();
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
          await _provider.searchSuggestions('a');
          // assert

          final wordsAreSuggestions = _provider.suggestionsMnemonicWords
              .every((word) => wordList.contains(word));

          expect(wordsAreSuggestions, true);
          expect(_provider.suggestionsMnemonicWords.length, 5);
        },
      );

      test(
        'clear suggestions for mnemonic word on import account',
        () async {
          // act
          await _provider.searchSuggestions('a');
          await _provider.clearSuggestions();
          // assert

          expect(_provider.suggestionsMnemonicWords.length, 0);
        },
      );

      test(
        'import account success',
        () async {
          // arrange
          when(() => _mockImportUsecase(
              mnemonic: any(named: "mnemonic"),
              password: any(named: "password"))).thenAnswer(
            (_) async => Right(tImportedAccount),
          );
          // act
          _provider.changeMnemonicWord(0, 'correct');
          _provider.changeMnemonicWord(1, 'gather');
          _provider.changeMnemonicWord(2, 'fork');
          final resultCheck = await _provider.checkMnemonicValid();
          await _provider.importAccount('passwordTest');
          // assert

          expect(resultCheck, true);
          verify(() => _mockImportUsecase(
              mnemonic: any(named: "mnemonic"),
              password: any(named: "password"))).called(2);
          verifyNoMoreInteractions(_mockImportUsecase);
        },
      );

      test(
        'import account fail',
        () async {
          // arrange
          when(() => _mockImportUsecase(
              mnemonic: any(named: "mnemonic"),
              password: any(named: "password"))).thenAnswer(
            (_) async => Left(ApiError()),
          );
          // act
          final resultCheck = await _provider.checkMnemonicValid();
          await _provider.importAccount('passwordTest');
          // assert

          expect(resultCheck, false);
          verify(() => _mockImportUsecase(
              mnemonic: any(named: "mnemonic"),
              password: any(named: "password"))).called(2);
          verifyNoMoreInteractions(_mockImportUsecase);
        },
      );
    },
  );
}
