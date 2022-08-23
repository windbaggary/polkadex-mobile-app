import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late SavePasswordUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late String tPassword;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = SavePasswordUseCase(accountRepository: _repository);
    tPassword = '123456';
  });

  group('SavePasswordUseCase tests', () {
    test(
      'must have success on saving a password',
      () async {
        // arrange
        when(() => _repository.savePasswordStorage(any())).thenAnswer(
          (_) async => true,
        );
        // act
        final result = await _usecase(password: tPassword);
        // assert

        expect(result, true);
        verify(() => _repository.savePasswordStorage(tPassword)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail on saving a password',
      () async {
        // arrange
        when(() => _repository.savePasswordStorage(any())).thenAnswer(
          (_) async => false,
        );
        // act
        final result = await _usecase(
          password: tPassword,
        );
        // assert

        expect(result, false);
        verify(() => _repository.savePasswordStorage(tPassword)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
