import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/setup/domain/repositories/imnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';

class _MnemonicRepositoryMock extends Mock implements IMnemonicRepository {}

void main() {
  late GenerateMnemonicUseCase _usecase;
  late _MnemonicRepositoryMock _repository;
  late String tMnemonic;

  setUp(() {
    _repository = _MnemonicRepositoryMock();
    _usecase = GenerateMnemonicUseCase(mnemonicRepository: _repository);
    tMnemonic =
        "correct gather fork rent problem ocean train pretty dinosaur captain myself rent";
  });

  group('GenerateMnemonicUsecase test', () {
    test(
      'must return success on mnemonic generation',
      () async {
        // arrange
        when(() => _repository.generateMnemonic()).thenAnswer(
          (_) async => Right(tMnemonic.split(' ')),
        );
        // act
        final result = await _usecase();
        // assert

        late List<String> mnemonic;

        result.fold(
          (_) => null,
          (resultMnemonic) => mnemonic = resultMnemonic,
        );

        expect(mnemonic.join(' '), tMnemonic);
        verify(() => _repository.generateMnemonic()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
