import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/account_model.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/imported_trade_account_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_trade_account_entity.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_sign_up_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_current_user_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_trade_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/resend_code_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_main_account_address_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_in_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_out_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_up_usecase.dart';
import 'package:test/test.dart';

class _MockSignUpUseCase extends Mock implements SignUpUseCase {}

class _MockSignInUseCase extends Mock implements SignInUseCase {}

class _MockSignOutUseCase extends Mock implements SignOutUseCase {}

class _MockConfirmSignUpUseCase extends Mock implements ConfirmSignUpUseCase {}

class _MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {
}

class _MockResendCodeUseCase extends Mock implements ResendCodeUseCase {}

class _MockGetAccountUseCase extends Mock implements GetAccountUseCase {}

class _MockDeleteAccountUsecase extends Mock implements DeleteAccountUseCase {}

class _MockDeletePasswordUsecase extends Mock implements DeletePasswordUseCase {
}

class _MockImportAccountUseCase extends Mock
    implements ImportTradeAccountUseCase {}

class _MockSaveAccountUseCase extends Mock implements SaveAccountUseCase {}

class _MockSavePasswordUseCase extends Mock implements SavePasswordUseCase {}

class _MockGetPasswordUseCase extends Mock implements GetPasswordUseCase {}

class _MockGetMainAccountAddressUseCase extends Mock
    implements GetMainAccountAddressUsecase {}

void main() {
  late _MockSignUpUseCase _mockSignUpUseCase;
  late _MockSignInUseCase _mockSignInUseCase;
  late _MockSignOutUseCase _mockSignOutUseCase;
  late _MockConfirmSignUpUseCase _mockConfirmSignUpUseCase;
  late _MockGetCurrentUserUseCase _mockGetCurrentUserUseCase;
  late _MockResendCodeUseCase _mockResendCodeUseCase;
  late _MockGetAccountUseCase _mockGetAccountUseCase;
  late _MockDeleteAccountUsecase _mockDeleteAccountUsecase;
  late _MockDeletePasswordUsecase _mockDeletePasswordUsecase;
  late _MockImportAccountUseCase _mockImportAccountUseCase;
  late _MockSaveAccountUseCase _mockSaveAccountUseCase;
  late _MockSavePasswordUseCase _mockSavePasswordUseCase;
  late _MockGetPasswordUseCase _mockGetPasswordUseCase;
  late _MockGetMainAccountAddressUseCase _mockGetMainAccountAddressUseCase;

  late AccountCubit cubit;
  late String tName;
  late String tAddress;
  late String tEmail;
  late MetaModel tMeta;
  late EncodingModel tEncoding;
  late String tPassword;
  late String tCode;
  late ApiError tError;
  late ImportedTradeAccountEntity tImportedTradeAccount;
  late AccountModel tAccountBioOff;
  late AccountModel tAccountBioOn;

  setUp(() {
    _mockSignUpUseCase = _MockSignUpUseCase();
    _mockSignInUseCase = _MockSignInUseCase();
    _mockSignOutUseCase = _MockSignOutUseCase();
    _mockConfirmSignUpUseCase = _MockConfirmSignUpUseCase();
    _mockGetCurrentUserUseCase = _MockGetCurrentUserUseCase();
    _mockResendCodeUseCase = _MockResendCodeUseCase();
    _mockGetAccountUseCase = _MockGetAccountUseCase();
    _mockDeleteAccountUsecase = _MockDeleteAccountUsecase();
    _mockDeletePasswordUsecase = _MockDeletePasswordUsecase();
    _mockImportAccountUseCase = _MockImportAccountUseCase();
    _mockSaveAccountUseCase = _MockSaveAccountUseCase();
    _mockSavePasswordUseCase = _MockSavePasswordUseCase();
    _mockGetPasswordUseCase = _MockGetPasswordUseCase();
    _mockGetMainAccountAddressUseCase = _MockGetMainAccountAddressUseCase();

    cubit = AccountCubit(
      signUpUseCase: _mockSignUpUseCase,
      signInUseCase: _mockSignInUseCase,
      signOutUseCase: _mockSignOutUseCase,
      confirmSignUpUseCase: _mockConfirmSignUpUseCase,
      getCurrentUserUseCase: _mockGetCurrentUserUseCase,
      getAccountStorageUseCase: _mockGetAccountUseCase,
      resendCodeUseCase: _mockResendCodeUseCase,
      deleteAccountUseCase: _mockDeleteAccountUsecase,
      deletePasswordUseCase: _mockDeletePasswordUsecase,
      importTradeAccountUseCase: _mockImportAccountUseCase,
      saveAccountUseCase: _mockSaveAccountUseCase,
      savePasswordUseCase: _mockSavePasswordUseCase,
      getPasswordUseCase: _mockGetPasswordUseCase,
      getMainAccountAddressUsecase: _mockGetMainAccountAddressUseCase,
    );

    tName = 'testName';
    tEmail = 'test@test.com';
    tPassword = 'testPassword';
    tError = ApiError(message: 'error');
    tCode = 'code';
    tAddress = 'k9o1dxJxQE8Zwm5Fy';
    tMeta = MetaModel(name: 'userName');
    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );
    tImportedTradeAccount = ImportedTradeAccountModel(
      address: tAddress,
      encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      encoding: tEncoding,
      meta: tMeta,
    );

    tAccountBioOff = AccountModel(
      name: "",
      email: tEmail,
      mainAddress: "",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
    tAccountBioOn = AccountModel(
      name: "",
      email: tEmail,
      mainAddress: "",
      biometricAccess: true,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );

    registerFallbackValue(tAccountBioOff);
    registerFallbackValue(tAccountBioOn);
  });

  group(
    'AccountCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, AccountInitial());
      });

      blocTest<AccountCubit, AccountState>(
        'Account found on local secure storage with no active session',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tAccountBioOff,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Left(
              tError,
            ),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
        },
        expect: () => [
          AccountLoaded(account: tAccountBioOff),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Logged in successfully using account found on local secure storage (biometric off)',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tAccountBioOff,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Left(
              tError,
            ),
          );
          when(
            () => _mockGetPasswordUseCase(),
          ).thenAnswer(
            (_) async => null,
          );
          when(
            () => _mockSignInUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOff),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
          await cubit.signInWithLocalAcc(password: tPassword);
        },
        expect: () => [
          AccountLoaded(account: tAccountBioOff),
          AccountLoading(),
          AccountLoggedIn(account: tAccountBioOff, password: tPassword),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Logged in successfully using account found on local secure storage (biometric on)',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tAccountBioOn,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Left(
              tError,
            ),
          );
          when(
            () => _mockGetPasswordUseCase(),
          ).thenAnswer(
            (_) async => tPassword,
          );
          when(
            () => _mockSignInUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOn),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
          await cubit.signInWithLocalAcc();
        },
        expect: () => [
          AccountLoaded(account: tAccountBioOn),
          AccountLoading(),
          AccountLoggedIn(account: tAccountBioOn, password: tPassword),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Failed to log in successfully using account found on local secure storage (biometric off)',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tAccountBioOff,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Left(
              tError,
            ),
          );
          when(
            () => _mockGetPasswordUseCase(),
          ).thenAnswer(
            (_) async => null,
          );
          when(
            () => _mockSignInUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Left(tError),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
          await cubit.signInWithLocalAcc(password: tPassword);
        },
        expect: () => [
          AccountLoaded(account: tAccountBioOff),
          AccountLoading(),
          AccountLoadedLogInError(
              account: tAccountBioOff, errorMessage: tError.message),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Log in interrupted using account found on local secure storage (biometric on)',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tAccountBioOff,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Left(
              tError,
            ),
          );
          when(
            () => _mockGetPasswordUseCase(),
          ).thenAnswer(
            (_) async => null,
          );
          when(
            () => _mockSignInUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Left(tError),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
          await cubit.signInWithLocalAcc();
        },
        expect: () => [
          AccountLoaded(account: tAccountBioOff),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Account not found on local secure storage',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => null,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Left(
              tError,
            ),
          );
          when(
            () => _mockSignOutUseCase(),
          ).thenAnswer(
            (_) async => Left(
              tError,
            ),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
        },
        expect: () => [
          AccountNotLoaded(),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Account found on local secure storage and with active session',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tAccountBioOff,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Right(unit),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
        },
        expect: () => [
          AccountLoggedIn(account: tAccountBioOff),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Account not found on local secure storage and with active session',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => null,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Right(unit),
          );
          when(
            () => _mockSignOutUseCase(),
          ).thenAnswer(
            (_) async => Left(
              tError,
            ),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
        },
        expect: () => [
          AccountNotLoaded(),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Logged out from local and remote account',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tAccountBioOff,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Right(unit),
          );
          when(
            () => _mockSignOutUseCase(),
          ).thenAnswer(
            (_) async => Right(unit),
          );
          when(
            () => _mockDeleteAccountUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockDeletePasswordUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
          await cubit.logout();
        },
        expect: () => [
          AccountLoggedIn(account: tAccountBioOff),
          AccountLoading(),
          AccountNotLoaded(),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Failed to log out from local and remote account',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tAccountBioOff,
          );
          when(
            () => _mockGetCurrentUserUseCase(),
          ).thenAnswer(
            (_) async => Right(unit),
          );
          when(
            () => _mockSignOutUseCase(),
          ).thenAnswer(
            (_) async => Left(tError),
          );
          when(
            () => _mockDeleteAccountUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockDeletePasswordUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccount();
          await cubit.logout();
        },
        expect: () => [
          AccountLoggedIn(account: tAccountBioOff),
          AccountLoading(),
          AccountLoggedInSignOutError(
            account: tAccountBioOff,
            password: null,
            errorMessage: tError.message,
          ),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Logged out from local',
        build: () {
          when(
            () => _mockDeleteAccountUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockDeletePasswordUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.localAccountLogout();
        },
        expect: () => [
          AccountLoading(),
          AccountNotLoaded(),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Signed in successfully (biometric off)',
        build: () {
          when(
            () => _mockSignInUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOff),
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockDeletePasswordUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.signIn(
            email: tEmail,
            password: tPassword,
            useBiometric: false,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountLoggedIn(
            account: tAccountBioOff,
            password: tPassword,
          ),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Signed in successfully (biometric on)',
        build: () {
          when(
            () => _mockSignInUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOn),
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockDeletePasswordUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.signIn(
            email: tEmail,
            password: tPassword,
            useBiometric: true,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountLoggedIn(
            account: tAccountBioOn,
            password: tPassword,
          ),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Failed to Sign in',
        build: () {
          when(
            () => _mockSignInUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Left(tError),
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockDeletePasswordUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.signIn(
            email: tEmail,
            password: tPassword,
            useBiometric: false,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountNotLoadedLogInError(errorMessage: tError.message),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Signed up successfully',
        build: () {
          when(
            () => _mockSignUpUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => Right(unit),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.signUp(
            email: tEmail,
            password: tPassword,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountVerifyingCode(),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Failed to Sign up',
        build: () {
          when(
            () => _mockSignUpUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => Left(tError),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.signUp(
            email: tEmail,
            password: tPassword,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountSignUpError(errorMessage: tError.message),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Sign up confirmed successfully (biometric on)',
        build: () {
          when(
            () => _mockConfirmSignUpUseCase(
              email: any(named: 'email'),
              code: any(named: 'code'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOff),
          );
          when(
            () => _mockDeletePasswordUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.confirmSignUp(
            email: tEmail,
            password: tPassword,
            code: tCode,
            useBiometric: false,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountLoggedIn(
            account: tAccountBioOff,
            password: tPassword,
          ),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Sign up confirmed successfully (biometric off)',
        build: () {
          when(
            () => _mockConfirmSignUpUseCase(
              email: any(named: 'email'),
              code: any(named: 'code'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOn),
          );
          when(
            () => _mockDeletePasswordUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.confirmSignUp(
            email: tEmail,
            password: tPassword,
            code: tCode,
            useBiometric: true,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountLoggedIn(
            account: tAccountBioOn,
            password: tPassword,
          ),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Failed to confirm Sign up',
        build: () {
          when(
            () => _mockConfirmSignUpUseCase(
              email: any(named: 'email'),
              code: any(named: 'code'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Left(tError),
          );
          when(
            () => _mockDeletePasswordUsecase(),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.confirmSignUp(
            email: tEmail,
            password: tPassword,
            code: tCode,
            useBiometric: false,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountConfirmSignUpError(errorMessage: tError.message),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Verification code resent',
        build: () {
          when(
            () => _mockResendCodeUseCase(
              email: any(named: 'email'),
            ),
          ).thenAnswer(
            (_) async => Right(unit),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.resendCode(
            email: tEmail,
          );
        },
        expect: () => [
          AccountCodeResent(),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Failed to resend verification code',
        build: () {
          when(
            () => _mockResendCodeUseCase(
              email: any(named: 'email'),
            ),
          ).thenAnswer(
            (_) async => Left(tError),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.resendCode(
            email: tEmail,
          );
        },
        expect: () => [
          AccountResendCodeError(errorMessage: tError.message),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Wallet added to current logged in account',
        build: () {
          when(
            () => _mockConfirmSignUpUseCase(
              email: any(named: 'email'),
              code: any(named: 'code'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOff),
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockSavePasswordUseCase(password: any(named: 'password')),
          ).thenAnswer(
            (_) async => true,
          );
          when(
            () => _mockGetMainAccountAddressUseCase(
              proxyAdrress: any(named: 'proxyAdrress'),
            ),
          ).thenAnswer(
            (_) async => Right(tAddress),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.confirmSignUp(
            email: tEmail,
            password: tPassword,
            code: 'test',
            useBiometric: false,
          );
          await cubit.addWalletToAccount(
            name: tName,
            importedTradeAccount: tImportedTradeAccount,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountLoggedIn(
            account: tAccountBioOff,
            password: tPassword,
          ),
          AccountLoading(),
          AccountLoggedInWalletAdded(
            account: tAccountBioOff.copyWith(
              name: tName,
              mainAddress: tAddress,
              importedTradeAccountEntity: tImportedTradeAccount,
            ),
            password: tPassword,
          ),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Failed to add wallet to current logged in account',
        build: () {
          when(
            () => _mockConfirmSignUpUseCase(
              email: any(named: 'email'),
              code: any(named: 'code'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOff),
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockSavePasswordUseCase(password: any(named: 'password')),
          ).thenAnswer(
            (_) async => true,
          );
          when(
            () => _mockGetMainAccountAddressUseCase(
              proxyAdrress: any(named: 'proxyAdrress'),
            ),
          ).thenAnswer(
            (_) async => Left(tError),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.confirmSignUp(
            email: tEmail,
            password: tPassword,
            code: 'test',
            useBiometric: false,
          );
          await cubit.addWalletToAccount(
            name: tName,
            importedTradeAccount: tImportedTradeAccount,
          );
        },
        expect: () => [
          AccountLoading(),
          AccountLoggedIn(
            account: tAccountBioOff,
            password: tPassword,
          ),
          AccountLoading(),
          AccountLoggedInMainAccountFetchError(
            account: tAccountBioOff,
            password: tPassword,
            errorMessage: tError.message,
          )
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Account biometric access switched on',
        build: () {
          when(
            () => _mockConfirmSignUpUseCase(
              email: any(named: 'email'),
              code: any(named: 'code'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOff),
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockSavePasswordUseCase(password: any(named: 'password')),
          ).thenAnswer(
            (_) async => true,
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.confirmSignUp(
            email: tEmail,
            password: tPassword,
            code: 'test',
            useBiometric: false,
          );
          await cubit.switchBiometricAccess();
        },
        expect: () => [
          AccountLoading(),
          AccountLoggedIn(
            account: tAccountBioOff,
            password: tPassword,
          ),
          AccountUpdatingBiometric(
            account: tAccountBioOff,
            password: tPassword,
          ),
          AccountLoggedIn(
            account: tAccountBioOn,
            password: tPassword,
          ),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Account biometric access switched off',
        build: () {
          when(
            () => _mockConfirmSignUpUseCase(
              email: any(named: 'email'),
              code: any(named: 'code'),
              useBiometric: any(named: 'useBiometric'),
            ),
          ).thenAnswer(
            (_) async => Right(tAccountBioOn),
          );
          when(
            () => _mockSaveAccountUseCase(
              keypairJson: any(named: 'keypairJson'),
            ),
          ).thenAnswer(
            (_) async {},
          );
          when(
            () => _mockSavePasswordUseCase(password: any(named: 'password')),
          ).thenAnswer(
            (_) async => true,
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.confirmSignUp(
            email: tEmail,
            password: tPassword,
            code: 'test',
            useBiometric: true,
          );
          await cubit.switchBiometricAccess();
        },
        expect: () => [
          AccountLoading(),
          AccountLoggedIn(
            account: tAccountBioOn,
            password: tPassword,
          ),
          AccountUpdatingBiometric(
            account: tAccountBioOn,
            password: tPassword,
          ),
          AccountLoggedIn(
            account: tAccountBioOff,
            password: tPassword,
          ),
        ],
      );
    },
  );
}
