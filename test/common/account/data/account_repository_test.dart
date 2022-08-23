import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/data/repositories/account_repository.dart';
import 'package:polkadex/features/setup/data/datasources/account_local_datasource.dart';
import 'package:polkadex/features/setup/data/datasources/account_remote_datasource.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

class _MockAccountLocalDatasource extends Mock
    implements AccountLocalDatasource {}

class _MockAccountRemoteDatasource extends Mock
    implements AccountRemoteDatasource {}

void main() {
  late _MockAccountLocalDatasource localDatasource;
  late _MockAccountRemoteDatasource remoteDatasource;
  late AccountRepository repository;

  late String tEmail;
  late String tCode;
  late String tPassword;
  late ApiError tError;
  late ImportedAccountEntity tAccount;
  late AmplifyException tAmplifyError;

  setUp(() {
    localDatasource = _MockAccountLocalDatasource();
    remoteDatasource = _MockAccountRemoteDatasource();
    repository = AccountRepository(
      accountLocalDatasource: localDatasource,
      accountRemoteDatasource: remoteDatasource,
    );

    tEmail = "test@test.com";
    tPassword = '123456';
    tCode = '654321';
    tError = ApiError(message: 'errorMessage');
    tAccount = ImportedAccountModel(
      name: "",
      email: tEmail,
      mainAddress: "",
      proxyAddress: "",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
    tAmplifyError = AmplifyException(tError.message);
  });

  group('Account repository tests', () {
    test('Must return a successful account signup response', () async {
      when(() => remoteDatasource.signUp(any(), any())).thenAnswer(
        (_) async => SignUpResult(
          isSignUpComplete: false,
          nextStep: AuthNextSignUpStep(signUpStep: 'testAuth'),
        ),
      );

      final result = await repository.signUp(tEmail, tPassword);

      late Unit successResult;

      result.fold(
        (_) => null,
        (signUpResult) => successResult = signUpResult,
      );

      expect(successResult, unit);
      verify(() => remoteDatasource.signUp(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a failed account signup response', () async {
      when(() => remoteDatasource.signUp(any(), any())).thenAnswer(
        (_) async => throw tAmplifyError,
      );

      final result = await repository.signUp(tEmail, tPassword);

      late ApiError failResult;

      result.fold(
        (error) => failResult = error,
        (_) => null,
      );

      expect(failResult.message, tError.message);
      verify(() => remoteDatasource.signUp(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a successful account confirm signup response', () async {
      when(() => remoteDatasource.confirmSignUp(any(), any())).thenAnswer(
        (_) async => SignUpResult(
          isSignUpComplete: false,
          nextStep: AuthNextSignUpStep(signUpStep: 'testAuth'),
        ),
      );

      final result = await repository.confirmSignUp(
        tEmail,
        tCode,
        false,
      );

      late ImportedAccountEntity successResult;

      result.fold(
        (_) => null,
        (confirmSignUpResult) => successResult = confirmSignUpResult,
      );

      expect(successResult, tAccount);
      verify(() => remoteDatasource.confirmSignUp(tEmail, tCode)).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a failed account confirm signup response', () async {
      when(() => remoteDatasource.confirmSignUp(any(), any())).thenAnswer(
        (_) async => throw tAmplifyError,
      );

      final result = await repository.confirmSignUp(
        tEmail,
        tCode,
        false,
      );

      late ApiError failResult;

      result.fold(
        (error) => failResult = error,
        (_) => null,
      );

      expect(failResult.message, tAmplifyError.message);
      verify(() => remoteDatasource.confirmSignUp(tEmail, tCode)).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a successful account signin response', () async {
      when(() => remoteDatasource.signIn(any(), any())).thenAnswer(
        (_) async => SignInResult(isSignedIn: true),
      );

      final result = await repository.signIn(
        tEmail,
        tPassword,
        false,
      );

      late ImportedAccountEntity successResult;

      result.fold(
        (_) => null,
        (signInResult) => successResult = signInResult,
      );

      expect(successResult, tAccount);
      verify(() => remoteDatasource.signIn(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a failed account signin response', () async {
      when(() => remoteDatasource.signIn(any(), any())).thenAnswer(
        (_) async => throw tAmplifyError,
      );

      final result = await repository.signIn(
        tEmail,
        tPassword,
        false,
      );

      late ApiError failResult;

      result.fold(
        (error) => failResult = error,
        (_) => null,
      );

      expect(failResult.message, tAmplifyError.message);
      verify(() => remoteDatasource.signIn(tEmail, tPassword)).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a successful account signout response', () async {
      when(() => remoteDatasource.signOut()).thenAnswer(
        (_) async => SignOutResult(),
      );

      final result = await repository.signOut();

      late Unit successResult;

      result.fold(
        (_) => null,
        (signOutResult) => successResult = signOutResult,
      );

      expect(successResult, unit);
      verify(() => remoteDatasource.signOut()).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a failed account signout response', () async {
      when(() => remoteDatasource.signOut()).thenAnswer(
        (_) async => throw tAmplifyError,
      );

      final result = await repository.signOut();

      late ApiError errorResult;

      result.fold(
        (error) => errorResult = error,
        (_) => null,
      );

      expect(errorResult.message, tAmplifyError.message);
      verify(() => remoteDatasource.signOut()).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a successful remote account fetch response', () async {
      when(() => remoteDatasource.getCurrentUser()).thenAnswer(
        (_) async => AuthUser(
          userId: 'userId',
          username: 'username',
        ),
      );

      final result = await repository.getCurrentUser();

      late Unit successResult;

      result.fold(
        (_) => null,
        (getCurrentUserResult) => successResult = getCurrentUserResult,
      );

      expect(successResult, unit);
      verify(() => remoteDatasource.getCurrentUser()).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a failed account signout response', () async {
      when(() => remoteDatasource.getCurrentUser()).thenAnswer(
        (_) async => throw tAmplifyError,
      );

      final result = await repository.getCurrentUser();

      late ApiError errorResult;

      result.fold(
        (error) => errorResult = error,
        (_) => null,
      );

      expect(errorResult.message, tAmplifyError.message);
      verify(() => remoteDatasource.getCurrentUser()).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a successful resend verification code response',
        () async {
      when(() => remoteDatasource.resendCode(any())).thenAnswer(
        (_) async => ResendSignUpCodeResult(AuthCodeDeliveryDetails()),
      );

      final result = await repository.resendCode(tEmail);

      late Unit successResult;

      result.fold(
        (_) => null,
        (resendCodeResult) => successResult = resendCodeResult,
      );

      expect(successResult, unit);
      verify(() => remoteDatasource.resendCode(tEmail)).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a failed resend verification code response', () async {
      when(() => remoteDatasource.resendCode(any())).thenAnswer(
        (_) async => throw tAmplifyError,
      );

      final result = await repository.resendCode(tEmail);

      late ApiError errorResult;

      result.fold(
        (error) => errorResult = error,
        (_) => null,
      );

      expect(errorResult.message, tAmplifyError.message);
      verify(() => remoteDatasource.resendCode(tEmail)).called(1);
      verifyNoMoreInteractions(remoteDatasource);
    });

    test('Must return a saved local account response', () async {
      when(() => localDatasource.saveAccountStorage(any())).thenAnswer(
        (_) async => true,
      );

      await repository.saveAccountStorage(json.encode(tAccount));

      verify(() => localDatasource.saveAccountStorage(json.encode(tAccount)))
          .called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test('Must return a fetched local account response', () async {
      when(() => localDatasource.getAccountStorage()).thenAnswer(
        (_) async => json.encode(tAccount),
      );

      final result = await repository.getAccountStorage();

      expect(result, tAccount);
      verify(() => localDatasource.getAccountStorage()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test('Must return a unsuccessful local account fetch response', () async {
      when(() => localDatasource.getAccountStorage()).thenAnswer(
        (_) async => null,
      );

      final result = await repository.getAccountStorage();

      expect(result, null);
      verify(() => localDatasource.getAccountStorage()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test('Must return a deleted local account response', () async {
      when(() => localDatasource.deleteAccountStorage()).thenAnswer(
        (_) async => true,
      );

      await repository.deleteAccountStorage();

      verify(() => localDatasource.deleteAccountStorage()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test('Must return a deleted local password response', () async {
      when(() => localDatasource.deletePasswordStorage()).thenAnswer(
        (_) async => true,
      );

      await repository.deletePasswordStorage();

      verify(() => localDatasource.deletePasswordStorage()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test('Must return a fetched local password response', () async {
      when(() => localDatasource.getPasswordStorage()).thenAnswer(
        (_) async => tPassword,
      );

      final result = await repository.getPasswordStorage();

      expect(result, tPassword);
      verify(() => localDatasource.getPasswordStorage()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test('Must return a unsuccessful local password fetch response', () async {
      when(() => localDatasource.getPasswordStorage()).thenAnswer(
        (_) async => null,
      );

      final result = await repository.getPasswordStorage();

      expect(result, null);
      verify(() => localDatasource.getPasswordStorage()).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test('Must return a saved local password fetch response', () async {
      when(() => localDatasource.savePasswordStorage(any())).thenAnswer(
        (_) async => true,
      );

      final result = await repository.savePasswordStorage(tPassword);

      expect(result, true);
      verify(() => localDatasource.savePasswordStorage(tPassword)).called(1);
      verifyNoMoreInteractions(localDatasource);
    });

    test('Must return a unsuccessful local password save response', () async {
      when(() => localDatasource.savePasswordStorage(any())).thenAnswer(
        (_) async => false,
      );

      final result = await repository.savePasswordStorage(tPassword);

      expect(result, false);
      verify(() => localDatasource.savePasswordStorage(tPassword)).called(1);
      verifyNoMoreInteractions(localDatasource);
    });
  });
}
