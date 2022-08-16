import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_sign_up_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/register_user_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_main_account_address_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_up_usecase.dart';
import 'package:test/test.dart';

class _MockSignUpUseCase extends Mock implements SignUpUseCase {}

class _MockConfirmSignUpUseCase extends Mock implements ConfirmSignUpUseCase {}

class _MockGetAccountUseCase extends Mock implements GetAccountUseCase {}

class _MockDeleteAccountUsecase extends Mock implements DeleteAccountUseCase {}

class _MockDeletePasswordUsecase extends Mock implements DeletePasswordUseCase {
}

class _MockImportAccountUseCase extends Mock implements ImportAccountUseCase {}

class _MockSaveAccountUseCase extends Mock implements SaveAccountUseCase {}

class _MockSavePasswordUseCase extends Mock implements SavePasswordUseCase {}

class _MockGetPasswordUseCase extends Mock implements GetPasswordUseCase {}

class _MockConfirmPasswordUseCase extends Mock
    implements ConfirmPasswordUseCase {}

class _MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

class _MockGetMainAccountAddressUseCase extends Mock
    implements GetMainAccountAddressUsecase {}

void main() {
  late _MockSignUpUseCase _mockSignUpUseCase;
  late _MockConfirmSignUpUseCase _mockConfirmSignUpUseCase;
  late _MockGetAccountUseCase _mockGetAccountUseCase;
  late _MockDeleteAccountUsecase _mockDeleteAccountUsecase;
  late _MockDeletePasswordUsecase _mockDeletePasswordUsecase;
  late _MockImportAccountUseCase _mockImportAccountUseCase;
  late _MockSaveAccountUseCase _mockSaveAccountUseCase;
  late _MockSavePasswordUseCase _mockSavePasswordUseCase;
  late _MockGetPasswordUseCase _mockGetPasswordUseCase;
  late _MockConfirmPasswordUseCase _mockConfirmPasswordUseCase;
  late _MockRegisterUserUseCase _mockRegisterUserUseCase;
  late _MockGetMainAccountAddressUseCase _mockGetMainAccountAddressUseCase;

  late AccountCubit cubit;
  late ImportedAccountModel tImportedAccountBioOff;
  late ImportedAccountModel tImportedAccountBioOn;
  late List<String> tMnemonicWords;
  late String tPassword;

  setUp(() {
    _mockSignUpUseCase = _MockSignUpUseCase();
    _mockConfirmSignUpUseCase = _MockConfirmSignUpUseCase();
    _mockGetAccountUseCase = _MockGetAccountUseCase();
    _mockDeleteAccountUsecase = _MockDeleteAccountUsecase();
    _mockDeletePasswordUsecase = _MockDeletePasswordUsecase();
    _mockImportAccountUseCase = _MockImportAccountUseCase();
    _mockSaveAccountUseCase = _MockSaveAccountUseCase();
    _mockSavePasswordUseCase = _MockSavePasswordUseCase();
    _mockGetPasswordUseCase = _MockGetPasswordUseCase();
    _mockConfirmPasswordUseCase = _MockConfirmPasswordUseCase();
    _mockRegisterUserUseCase = _MockRegisterUserUseCase();
    _mockGetMainAccountAddressUseCase = _MockGetMainAccountAddressUseCase();

    cubit = AccountCubit(
      signUpUseCase: _mockSignUpUseCase,
      confirmSignUpUseCase: _mockConfirmSignUpUseCase,
      getAccountStorageUseCase: _mockGetAccountUseCase,
      deleteAccountUseCase: _mockDeleteAccountUsecase,
      deletePasswordUseCase: _mockDeletePasswordUsecase,
      importAccountUseCase: _mockImportAccountUseCase,
      saveAccountUseCase: _mockSaveAccountUseCase,
      savePasswordUseCase: _mockSavePasswordUseCase,
      getPasswordUseCase: _mockGetPasswordUseCase,
      confirmPasswordUseCase: _mockConfirmPasswordUseCase,
      registerUserUseCase: _mockRegisterUserUseCase,
      getMainAccountAddressUsecase: _mockGetMainAccountAddressUseCase,
    );
    tImportedAccountBioOff = ImportedAccountModel(
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      proxyAddress: "k9o1dxJxQE8Zwm5Fy",
      name: 'test',
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
    tImportedAccountBioOn = ImportedAccountModel(
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      proxyAddress: "k9o1dxJxQE8Zwm5Fy",
      name: 'test',
      biometricAccess: true,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
    tMnemonicWords = ['word', 'word', 'word', 'word', 'word'];
    tPassword = 'test';

    registerFallbackValue(tImportedAccountBioOff);
    registerFallbackValue(tImportedAccountBioOn);
  });

  group(
    'AccountCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, AccountInitial());
      });

      blocTest<AccountCubit, AccountState>(
        'Account found on local secure storage',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tImportedAccountBioOff,
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccountData();
        },
        expect: () => [
          AccountLoaded(account: tImportedAccountBioOff),
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
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccountData();
        },
        expect: () => [
          AccountNotLoaded(),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Logged out from account',
        build: () {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tImportedAccountBioOff,
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
          await cubit.loadAccountData();
          await cubit.logout();
        },
        expect: () => [
          AccountLoaded(account: tImportedAccountBioOff),
          AccountNotLoaded(),
        ],
      );

      test(
        'Biometric verification success for account creation',
        () async {
          when(
            () => _mockSavePasswordUseCase(password: any(named: 'password')),
          ).thenAnswer(
            (_) async => true,
          );

          final result = await cubit.savePassword('test');

          expect(result, true);
          verify(() =>
                  _mockSavePasswordUseCase(password: any(named: 'password')))
              .called(1);
          verifyNoMoreInteractions(_mockSavePasswordUseCase);
        },
      );

      test(
        'Biometric verification fail for account creation',
        () async {
          when(
            () => _mockSavePasswordUseCase(password: any(named: 'password')),
          ).thenAnswer(
            (_) async => false,
          );

          final result = await cubit.savePassword('test');

          expect(result, false);
          verify(() =>
                  _mockSavePasswordUseCase(password: any(named: 'password')))
              .called(1);
          verifyNoMoreInteractions(_mockSavePasswordUseCase);
        },
      );

      test(
        'Biometric verification success for account login',
        () async {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tImportedAccountBioOff,
          );
          when(
            () => _mockGetPasswordUseCase(),
          ).thenAnswer(
            (_) async => 'test',
          );
          when(
            () => _mockConfirmPasswordUseCase(
              account: any(named: 'account'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => true,
          );

          await cubit.loadAccountData();
          final result = await cubit.authenticateBiometric();

          expect(result, true);
          verify(() => _mockGetPasswordUseCase()).called(1);
          verifyNoMoreInteractions(_mockSavePasswordUseCase);
        },
      );

      test(
        'Biometric verification fail for account login',
        () async {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tImportedAccountBioOff,
          );
          when(
            () => _mockGetPasswordUseCase(),
          ).thenAnswer(
            (_) async => 'test',
          );
          when(
            () => _mockConfirmPasswordUseCase(
              account: any(named: 'account'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => false,
          );

          await cubit.loadAccountData();
          final result = await cubit.authenticateBiometric();

          expect(result, false);
          verify(() => _mockGetPasswordUseCase()).called(1);
          verifyNoMoreInteractions(_mockSavePasswordUseCase);
        },
      );

      blocTest<AccountCubit, AccountState>(
        'Account created and saved in secure storage',
        build: () {
          when(
            () => _mockImportAccountUseCase(
              mnemonic: any(named: 'mnemonic'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => Right(tImportedAccountBioOff),
          );
          when(
            () => _mockRegisterUserUseCase(
              address: any(named: 'address'),
            ),
          ).thenAnswer(
            (_) async => 'test',
          );
          when(
            () => _mockGetMainAccountAddressUseCase(
                proxyAdrress: any(named: 'proxyAdrress')),
          ).thenAnswer(
            (_) async => Right('k9o1dxJxQE8Zwm5Fy'),
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
          await cubit.saveAccount(tMnemonicWords, 'test', 'test', false, false);
        },
        expect: () => [
          AccountLoaded(account: tImportedAccountBioOff, password: tPassword),
        ],
      );

      test(
        'Password verification success for account login',
        () async {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tImportedAccountBioOff,
          );
          when(
            () => _mockConfirmPasswordUseCase(
              account: any(named: 'account'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => true,
          );

          await cubit.loadAccountData();
          final result = await cubit.confirmPassword('test');

          expect(result, true);
          verify(() => _mockConfirmPasswordUseCase(
                account: any(named: 'account'),
                password: any(named: 'password'),
              )).called(1);
          verifyNoMoreInteractions(_mockConfirmPasswordUseCase);
        },
      );

      test(
        'Password verification fail for account login',
        () async {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tImportedAccountBioOff,
          );
          when(
            () => _mockConfirmPasswordUseCase(
              account: any(named: 'account'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => false,
          );

          await cubit.loadAccountData();
          final result = await cubit.confirmPassword('test');

          expect(result, false);
          verify(() => _mockConfirmPasswordUseCase(
                account: any(named: 'account'),
                password: any(named: 'password'),
              )).called(1);
          verifyNoMoreInteractions(_mockConfirmPasswordUseCase);
        },
      );

      blocTest<AccountCubit, AccountState>(
        'Account biometric access switched on',
        build: () {
          when(
            () => _mockImportAccountUseCase(
              mnemonic: any(named: 'mnemonic'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => Right(tImportedAccountBioOff),
          );
          when(
            () => _mockRegisterUserUseCase(
              address: any(named: 'address'),
            ),
          ).thenAnswer(
            (_) async => 'test',
          );
          when(
            () => _mockGetMainAccountAddressUseCase(
                proxyAdrress: any(named: 'proxyAdrress')),
          ).thenAnswer(
            (_) async => Right('k9o1dxJxQE8Zwm5Fy'),
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
          await cubit.saveAccount(tMnemonicWords, 'test', 'test', false, false);
          await cubit.switchBiometricAccess();
        },
        expect: () => [
          AccountLoaded(account: tImportedAccountBioOff, password: tPassword),
          AccountUpdatingBiometric(
              account: tImportedAccountBioOff, password: tPassword),
          AccountLoaded(account: tImportedAccountBioOn, password: tPassword),
        ],
      );

      blocTest<AccountCubit, AccountState>(
        'Account biometric access switched off',
        build: () {
          when(
            () => _mockImportAccountUseCase(
              mnemonic: any(named: 'mnemonic'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => Right(tImportedAccountBioOn),
          );
          when(
            () => _mockRegisterUserUseCase(
              address: any(named: 'address'),
            ),
          ).thenAnswer(
            (_) async => 'test',
          );
          when(
            () => _mockGetMainAccountAddressUseCase(
                proxyAdrress: any(named: 'proxyAdrress')),
          ).thenAnswer(
            (_) async => Right('k9o1dxJxQE8Zwm5Fy'),
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
          await cubit.saveAccount(tMnemonicWords, 'test', 'test', false, true);
          await cubit.switchBiometricAccess();
        },
        expect: () => [
          AccountLoaded(account: tImportedAccountBioOn, password: tPassword),
          AccountUpdatingBiometric(
              account: tImportedAccountBioOn, password: tPassword),
          AccountLoaded(account: tImportedAccountBioOff, password: tPassword),
        ],
      );
    },
  );
}
