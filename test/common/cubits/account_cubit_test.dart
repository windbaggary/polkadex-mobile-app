import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_and_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/register_user_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';
import 'package:test/test.dart';

class _MockGetAccountUseCase extends Mock implements GetAccountUseCase {}

class _MockDeleteAccountAndPasswordUsecase extends Mock
    implements DeleteAccountAndPasswordUseCase {}

class _MockImportAccountUseCase extends Mock implements ImportAccountUseCase {}

class _MockSaveAccountUseCase extends Mock implements SaveAccountUseCase {}

class _MockSavePasswordUseCase extends Mock implements SavePasswordUseCase {}

class _MockGetPasswordUseCase extends Mock implements GetPasswordUseCase {}

class _MockConfirmPasswordUseCase extends Mock
    implements ConfirmPasswordUseCase {}

class _MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

void main() {
  late _MockGetAccountUseCase _mockGetAccountUseCase;
  late _MockDeleteAccountAndPasswordUsecase
      _mockDeleteAccountAndPasswordUsecase;
  late _MockImportAccountUseCase _mockImportAccountUseCase;
  late _MockSaveAccountUseCase _mockSaveAccountUseCase;
  late _MockSavePasswordUseCase _mockSavePasswordUseCase;
  late _MockGetPasswordUseCase _mockGetPasswordUseCase;
  late _MockConfirmPasswordUseCase _mockConfirmPasswordUseCase;
  late _MockRegisterUserUseCase _mockRegisterUserUseCase;

  late AccountCubit cubit;
  late MetaModel tMeta;
  late EncodingModel tEncoding;
  late ImportedAccountModel tImportedAccount;
  late List<String> tMnemonicWords;

  setUp(() {
    _mockGetAccountUseCase = _MockGetAccountUseCase();
    _mockDeleteAccountAndPasswordUsecase =
        _MockDeleteAccountAndPasswordUsecase();
    _mockImportAccountUseCase = _MockImportAccountUseCase();
    _mockSaveAccountUseCase = _MockSaveAccountUseCase();
    _mockSavePasswordUseCase = _MockSavePasswordUseCase();
    _mockGetPasswordUseCase = _MockGetPasswordUseCase();
    _mockConfirmPasswordUseCase = _MockConfirmPasswordUseCase();
    _mockRegisterUserUseCase = _MockRegisterUserUseCase();

    cubit = AccountCubit(
      getAccountStorageUseCase: _mockGetAccountUseCase,
      deleteAccountAndPasswordUseCase: _mockDeleteAccountAndPasswordUsecase,
      importAccountUseCase: _mockImportAccountUseCase,
      saveAccountUseCase: _mockSaveAccountUseCase,
      savePasswordUseCase: _mockSavePasswordUseCase,
      getPasswordUseCase: _mockGetPasswordUseCase,
      confirmPasswordUseCase: _mockConfirmPasswordUseCase,
      registerUserUseCase: _mockRegisterUserUseCase,
    );

    tMeta = MetaModel(name: 'userName');
    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );
    tImportedAccount = ImportedAccountModel(
      encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      encoding: tEncoding,
      address: "k9o1dxJxQE8Zwm5Fy",
      meta: tMeta,
      biometricAccess: false,
      name: 'test',
    );
    tMnemonicWords = ['word', 'word', 'word', 'word', 'word'];

    registerFallbackValue(tImportedAccount);
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
            (_) async => tImportedAccount,
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadAccountData();
        },
        expect: () => [
          AccountLoaded(account: tImportedAccount),
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
            (_) async => tImportedAccount,
          );
          when(
            () => _mockDeleteAccountAndPasswordUsecase(),
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
          AccountLoaded(account: tImportedAccount),
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
            (_) async => tImportedAccount,
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
            (_) async => tImportedAccount,
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
            (_) async => Right(tImportedAccount),
          );
          when(
            () => _mockRegisterUserUseCase(
              account: any(named: 'account'),
            ),
          ).thenAnswer(
            (_) async => true,
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
          await cubit.saveAccount(tMnemonicWords, 'test', 'test', false);
        },
        expect: () => [
          AccountLoaded(account: tImportedAccount),
        ],
      );

      test(
        'Password verification success for account login',
        () async {
          when(
            () => _mockGetAccountUseCase(),
          ).thenAnswer(
            (_) async => tImportedAccount,
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
            (_) async => tImportedAccount,
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
    },
  );
}
