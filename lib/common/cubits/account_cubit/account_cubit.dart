import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_sign_up_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_main_account_address_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_up_usecase.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required SignUpUseCase signUpUseCase,
    required ConfirmSignUpUseCase confirmSignUpUseCase,
    required GetAccountUseCase getAccountStorageUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required DeletePasswordUseCase deletePasswordUseCase,
    required ImportAccountUseCase importAccountUseCase,
    required SaveAccountUseCase saveAccountUseCase,
    required SavePasswordUseCase savePasswordUseCase,
    required GetPasswordUseCase getPasswordUseCase,
    required ConfirmPasswordUseCase confirmPasswordUseCase,
    required GetMainAccountAddressUsecase getMainAccountAddressUsecase,
  })  : _signUpUseCase = signUpUseCase,
        _confirmSignUpUseCase = confirmSignUpUseCase,
        _getAccountStorageUseCase = getAccountStorageUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _deletePasswordUseCase = deletePasswordUseCase,
        _importAccountUseCase = importAccountUseCase,
        _saveAccountUseCase = saveAccountUseCase,
        _savePasswordUseCase = savePasswordUseCase,
        _getPasswordUseCase = getPasswordUseCase,
        _confirmPasswordUseCase = confirmPasswordUseCase,
        _getMainAccountAddressUsecase = getMainAccountAddressUsecase,
        super(AccountInitial());

  final SignUpUseCase _signUpUseCase;
  final ConfirmSignUpUseCase _confirmSignUpUseCase;
  final GetAccountUseCase _getAccountStorageUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final DeletePasswordUseCase _deletePasswordUseCase;
  final ImportAccountUseCase _importAccountUseCase;
  final SaveAccountUseCase _saveAccountUseCase;
  final SavePasswordUseCase _savePasswordUseCase;
  final GetPasswordUseCase _getPasswordUseCase;
  final ConfirmPasswordUseCase _confirmPasswordUseCase;
  final GetMainAccountAddressUsecase _getMainAccountAddressUsecase;

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

  Future<void> loadAccountData() async {
    final account = await _getAccountStorageUseCase();

    account != null
        ? emit(AccountLoaded(account: account))
        : emit(AccountNotLoaded());
  }

  Future<void> logout() async {
    emit(AccountNotLoaded());

    await _deleteAccountUseCase();
    await _deletePasswordUseCase();

    return;
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final result = await _signUpUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (error) => emit(
        AccountNotLoaded(
          errorMessage: error.message,
        ),
      ),
      (_) => emit(
        AccountVerifyingCode(
          email: email,
          password: password,
        ),
      ),
    );
  }

  Future<void> confirmSignUp({
    required String email,
    required String password,
    required String code,
    required bool useBiometric,
  }) async {
    final result = await _confirmSignUpUseCase(
      email: email,
      code: code,
      useBiometric: useBiometric,
    );

    await result.fold(
      (error) async => emit(
        AccountNotLoaded(
          errorMessage: error.message,
        ),
      ),
      (newAccount) async {
        await _saveAccountUseCase(keypairJson: json.encode(newAccount));

        if (useBiometric) {
          await savePassword(password);
        }

        emit(
          AccountLoaded(
            account: newAccount,
            password: password,
          ),
        );
      },
    );
  }

  Future<bool> savePassword(String password) async {
    return await _savePasswordUseCase(password: password);
  }

  Future<bool> signInWithBiometric() async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      final password = await _getPasswordUseCase();

      return await signIn(password!);
    }

    return false;
  }

  Future<bool> signIn(String password) async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      emit(AccountPasswordValidating(account: currentState.account));

      //TODO: execute signIn usecase

      emit(
        AccountLoaded(
          account: currentState.account,
          password: password,
        ),
      );

      return true;
    }

    return false;
  }

  Future<void> switchBiometricAccess() async {
    final currentState = state;

    if (currentState is AccountLoaded) {
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
        AccountLoaded(
          account: acc,
          password: currentState.password,
        ),
      );
    }

    return;
  }

  Future<void> changeLockTimer(EnumTimerIntervalTypes newInterval) async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      emit(AccountUpdatingTimer(
        account: currentState.account,
        password: currentState.password,
      ));

      ImportedAccountEntity acc = (currentState.account as ImportedAccountModel)
          .copyWith(timerInterval: newInterval);

      await _saveAccountUseCase(keypairJson: json.encode(acc));
      emit(
        AccountLoaded(
          account: acc,
          password: currentState.password,
        ),
      );
    }
  }
}
