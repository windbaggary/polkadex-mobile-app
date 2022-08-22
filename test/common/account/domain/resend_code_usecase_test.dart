import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/resend_code_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late ResendCodeUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late String tEmail;
  late ApiError tError;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = ResendCodeUseCase(accountRepository: _repository);
    tEmail = "test@test.com";
    tError = ApiError(message: '');
  });

  group('ResendCodeUseCase tests', () {
    test(
      'must have success on resending the verification code',
      () async {
        // arrange
        when(() => _repository.resendCode(any())).thenAnswer(
          (_) async => Right(unit),
        );
        // act
        final result = await _usecase(email: tEmail);
        // assert

        late Unit resultAccount;

        result.fold(
          (_) => null,
          (result) => resultAccount = result,
        );

        expect(resultAccount, unit);
        verify(() => _repository.resendCode(tEmail)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail on resending the verification code',
      () async {
        // arrange
        when(() => _repository.resendCode(any())).thenAnswer(
          (_) async => Left(tError),
        );
        // act
        final result = await _usecase(email: tEmail);
        // assert

        late ApiError resultError;

        result.fold(
          (error) => resultError = error,
          (_) => null,
        );

        expect(resultError, tError);
        verify(() => _repository.resendCode(tEmail)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
