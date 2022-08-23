import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/get_password_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late GetPasswordUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late String tPassword;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = GetPasswordUseCase(accountRepository: _repository);
    tPassword = '123456';
  });

  group('GetPasswordUseCase tests', () {
    test(
      'must have success on getting the local account password',
      () async {
        // arrange
        when(() => _repository.getPasswordStorage()).thenAnswer(
          (_) async => tPassword,
        );
        // act
        final result = await _usecase();
        // assert

        expect(result, tPassword);
        verify(() => _repository.getPasswordStorage()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail on getting the local account password',
      () async {
        // arrange
        when(() => _repository.getPasswordStorage()).thenAnswer(
          (_) async => null,
        );
        // act
        final result = await _usecase();
        // assert

        expect(result, null);
        verify(() => _repository.getPasswordStorage()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
