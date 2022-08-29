import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/account_model.dart';
import 'package:polkadex/features/setup/domain/entities/account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_in_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late SignInUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late AccountEntity tAccount;
  late String tEmail;
  late String tPassword;
  late ApiError tError;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = SignInUseCase(accountRepository: _repository);
    tEmail = "test@test.com";
    tAccount = AccountModel(
      name: "",
      email: tEmail,
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
    tPassword = '123456';
    tError = ApiError(message: '');
  });

  group('SignInUseCase tests', () {
    test(
      'must have success on signin in',
      () async {
        // arrange
        when(() => _repository.signIn(any(), any(), any())).thenAnswer(
          (_) async => Right(tAccount),
        );
        // act
        final result = await _usecase(
          email: tEmail,
          password: tPassword,
          useBiometric: false,
        );
        // assert

        late AccountEntity resultAccount;

        result.fold(
          (_) => null,
          (result) => resultAccount = result,
        );

        expect(resultAccount, tAccount);
        verify(() => _repository.signIn(tEmail, tPassword, false)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail on signing in',
      () async {
        // arrange
        when(() => _repository.signIn(any(), any(), any())).thenAnswer(
          (_) async => Left(tError),
        );
        // act
        final result = await _usecase(
          email: tEmail,
          password: tPassword,
          useBiometric: false,
        );
        // assert

        late ApiError error;

        result.fold(
          (resultError) => error = resultError,
          (_) => null,
        );

        expect(error, tError);
        verify(() => _repository.signIn(tEmail, tPassword, false)).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
