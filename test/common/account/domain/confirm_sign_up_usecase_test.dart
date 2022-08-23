import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_sign_up_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late ConfirmSignUpUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late String tEmail;
  late String tCode;
  late String tProxyAddress;
  late ImportedAccountEntity tAccount;
  late ApiError tError;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = ConfirmSignUpUseCase(accountRepository: _repository);
    tEmail = "test@test.com";
    tCode = '123456';
    tProxyAddress = "k9o1dxJxQE8Zwm5Fy";
    tAccount = ImportedAccountModel(
      name: '',
      email: 'test',
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      proxyAddress: tProxyAddress,
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
    tError = ApiError(message: '');
  });

  group('ConfirmSignUpUseCase tests', () {
    test(
      'must have success on confirming the sign up',
      () async {
        // arrange
        when(() => _repository.confirmSignUp(any(), any(), any())).thenAnswer(
          (_) async => Right(tAccount),
        );
        // act
        final result = await _usecase(
          email: tEmail,
          code: tCode,
          useBiometric: false,
        );
        // assert

        late ImportedAccountEntity resultAccount;

        result.fold(
          (_) => null,
          (result) => resultAccount = result,
        );

        expect(resultAccount, tAccount);
        verify(() => _repository.confirmSignUp(
              tEmail,
              tCode,
              false,
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail on confirming the sign up',
      () async {
        // arrange
        when(() => _repository.confirmSignUp(any(), any(), any())).thenAnswer(
          (_) async => Left(tError),
        );
        // act
        final result = await _usecase(
          email: tEmail,
          code: tCode,
          useBiometric: false,
        );
        // assert

        late ApiError resultError;

        result.fold(
          (error) => resultError = error,
          (_) => null,
        );

        expect(resultError, tError);
        verify(() => _repository.confirmSignUp(
              tEmail,
              tCode,
              false,
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
