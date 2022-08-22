import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_sign_up_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_current_user_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_main_account_address_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/resend_code_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_in_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_out_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_up_usecase.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
    required SignOutUseCase signOutUseCase,
    required ConfirmSignUpUseCase confirmSignUpUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required ResendCodeUseCase resendCodeUseCase,
    required GetAccountUseCase getAccountStorageUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required DeletePasswordUseCase deletePasswordUseCase,
    required ImportAccountUseCase importAccountUseCase,
    required SaveAccountUseCase saveAccountUseCase,
    required SavePasswordUseCase savePasswordUseCase,
    required GetPasswordUseCase getPasswordUseCase,
    required GetMainAccountAddressUsecase getMainAccountAddressUsecase,
  })  : _signUpUseCase = signUpUseCase,
        _signInUseCase = signInUseCase,
        _signOutUseCase = signOutUseCase,
        _confirmSignUpUseCase = confirmSignUpUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        _resendCodeUseCase = resendCodeUseCase,
        _getAccountStorageUseCase = getAccountStorageUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _deletePasswordUseCase = deletePasswordUseCase,
        _saveAccountUseCase = saveAccountUseCase,
        _savePasswordUseCase = savePasswordUseCase,
        _getPasswordUseCase = getPasswordUseCase,
        super(AccountInitial());

  final SignUpUseCase _signUpUseCase;
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final ConfirmSignUpUseCase _confirmSignUpUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final ResendCodeUseCase _resendCodeUseCase;
  final GetAccountUseCase _getAccountStorageUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final DeletePasswordUseCase _deletePasswordUseCase;
  final SaveAccountUseCase _saveAccountUseCase;
  final SavePasswordUseCase _savePasswordUseCase;
  final GetPasswordUseCase _getPasswordUseCase;

  String get accountName {
    final currentState = state;

    return currentState is AccountLoaded ? currentState.account.email : '';
  }

  String get mainAccountAddress {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.mainAddress
        : '';
  }

  String get proxyAccountAddress {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.proxyAddress
        : '';
  }

  bool get biometricAccess {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.biometricAccess
        : false;
  }

  EnumTimerIntervalTypes get timerInterval {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.timerInterval
        : EnumTimerIntervalTypes.oneMinute;
  }

  Future<void> loadAccount() async {
    final localAccount = await _getAccountStorageUseCase();
    final resultRemoteAccount = await _getCurrentUserUseCase();

    if (localAccount != null) {
      await resultRemoteAccount.fold(
        (_) async => emit(
          AccountLoaded(
            account: localAccount,
          ),
        ),
        (remoteAccount) async => emit(
          AccountLoggedIn(account: localAccount),
        ),
      );
    } else {
      if (resultRemoteAccount.isRight()) {
        await _signOutUseCase();
      }

      emit(AccountNotLoaded());
    }
  }

  Future<void> logout() async {
    emit(AccountLoading());

    final resultSignOut = await _signOutUseCase();

    await resultSignOut.fold(
      (error) async => emit(
        AccountSignOutError(errorMessage: error.message),
      ),
      (_) async {
        await _removeLocalData();

        emit(AccountNotLoaded());
      },
    );
  }

  Future<void> localAccountLogout() async {
    emit(AccountLoading());

    await _removeLocalData();

    emit(AccountNotLoaded());
  }

  Future<void> _removeLocalData() async {
    await _deleteAccountUseCase();
    await _deletePasswordUseCase();
  }

  Future<bool> savePassword(String password) async {
    return await _savePasswordUseCase(password: password);
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    emit(AccountLoading());

    final result = await _signUpUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (error) => emit(
        AccountSignUpError(
          errorMessage: error.message,
        ),
      ),
      (_) => emit(
        AccountVerifyingCode(),
      ),
    );
  }

  Future<void> confirmSignUp({
    required String email,
    required String password,
    required String code,
    required bool useBiometric,
  }) async {
    emit(AccountLoading());

    final result = await _confirmSignUpUseCase(
      email: email,
      code: code,
      useBiometric: useBiometric,
    );

    await result.fold(
      (error) async {
        await _deletePasswordUseCase();

        emit(
          AccountConfirmSignUpError(
            errorMessage: error.message,
          ),
        );
      },
      (newAccount) async {
        await _saveAccountUseCase(keypairJson: json.encode(newAccount));

        emit(
          AccountLoggedIn(
            account: newAccount,
            password: password,
          ),
        );
      },
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
    required bool useBiometric,
  }) async {
    emit(AccountLoading());

    final result = await _signInUseCase(
      email: email,
      password: password,
      useBiometric: useBiometric,
    );

    await result.fold(
      (error) async {
        await _deletePasswordUseCase();

        emit(
          AccountLogInError(
            errorMessage: error.message,
          ),
        );
      },
      (newAccount) async {
        await _saveAccountUseCase(keypairJson: json.encode(newAccount));

        emit(
          AccountLoggedIn(
            account: newAccount,
            password: password,
          ),
        );
      },
    );
  }

  Future<void> signInWithLocalAcc({
    String? password,
  }) async {
    final currentState = state;
    final passwordSignUp = password ?? await _getPasswordUseCase();

    if (passwordSignUp == null) {
      return;
    }

    emit(AccountLoading());

    if (currentState is AccountLoaded) {
      final result = await _signInUseCase(
        email: currentState.account.email,
        password: passwordSignUp,
        useBiometric: password == null,
      );

      await result.fold(
        (error) async {
          emit(
            AccountLogInError(
              errorMessage: error.message,
            ),
          );
        },
        (_) async {
          emit(
            AccountLoggedIn(
              account: currentState.account,
              password: passwordSignUp,
            ),
          );
        },
      );
    }
  }

  Future<void> resendCode({required String email}) async {
    final result = await _resendCodeUseCase(email: email);

    await result.fold(
      (error) async => emit(
        AccountResendCodeError(errorMessage: error.message),
      ),
      (_) async => emit(
        AccountCodeResent(),
      ),
    );
  }

  Future<void> switchBiometricAccess() async {
    final currentState = state;

    if (currentState is AccountLoggedIn) {
      final currentBioAccess = currentState.account.biometricAccess;

      emit(
        AccountUpdatingBiometric(
          account: currentState.account,
          password: currentState.password,
        ),
      );

      ImportedAccountEntity acc = (currentState.account as ImportedAccountModel)
          .copyWith(biometricAccess: !currentBioAccess);

      await _saveAccountUseCase(keypairJson: json.encode(acc));
      emit(
        AccountLoggedIn(
          account: acc,
          password: currentState.password,
        ),
      );
    }

    return;
  }

  Future<void> changeLockTimer(EnumTimerIntervalTypes newInterval) async {
    final currentState = state;

    if (currentState is AccountLoggedIn) {
      emit(AccountUpdatingTimer(
        account: currentState.account,
        password: currentState.password,
      ));

      ImportedAccountEntity acc = (currentState.account as ImportedAccountModel)
          .copyWith(timerInterval: newInterval);

      await _saveAccountUseCase(keypairJson: json.encode(acc));
      emit(
        AccountLoggedIn(
          account: acc,
          password: currentState.password,
        ),
      );
    }
  }
}
