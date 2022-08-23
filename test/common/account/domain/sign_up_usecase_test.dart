import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_up_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late SignUpUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late String tEmail;
  late String tPassword;
  late ApiError tError;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = SignUpUseCase(accountRepository: _repository);
    tEmail = "test@test.com";
    tPassword = '123456';
    tError = ApiError(message: '');
  });

  group('SignUpUseCase tests', () {
    test(
      'must have success on signing up',
      () async {
        // arrange
        when(() => _repository.signUp(any(), any())).thenAnswer(
          (_) async => Right(unit),
        );
        // act
        final result = await _usecase(
          email: tEmail,
          password: tPassword,
        );
        // assert

        late Unit resultAccount;

        result.fold(
          (_) => null,
          (result) => resultAccount = result,
        );

        expect(resultAccount, unit);
        verify(() => _repository.signUp(tEmail, tPassword)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail on signing up',
      () async {
        // arrange
        when(() => _repository.signUp(any(), any())).thenAnswer(
          (_) async => Left(tError),
        );
        // act
        final result = await _usecase(
          email: tEmail,
          password: tPassword,
        );
        // assert

        late ApiError error;

        result.fold(
          (resultError) => error = resultError,
          (_) {},
        );

        expect(error, tError);
        verify(() => _repository.signUp(tEmail, tPassword)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
