import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/register_user_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required GetAccountUseCase getAccountStorageUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required DeletePasswordUseCase deletePasswordUseCase,
    required ImportAccountUseCase importAccountUseCase,
    required SaveAccountUseCase saveAccountUseCase,
    required SavePasswordUseCase savePasswordUseCase,
    required GetPasswordUseCase getPasswordUseCase,
    required ConfirmPasswordUseCase confirmPasswordUseCase,
    required RegisterUserUseCase registerUserUseCase,
  })  : _getAccountStorageUseCase = getAccountStorageUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _deletePasswordUseCase = deletePasswordUseCase,
        _importAccountUseCase = importAccountUseCase,
        _saveAccountUseCase = saveAccountUseCase,
        _savePasswordUseCase = savePasswordUseCase,
        _getPasswordUseCase = getPasswordUseCase,
        _confirmPasswordUseCase = confirmPasswordUseCase,
        _registerUserUseCase = registerUserUseCase,
        super(AccountInitial());

  final GetAccountUseCase _getAccountStorageUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final DeletePasswordUseCase _deletePasswordUseCase;
  final ImportAccountUseCase _importAccountUseCase;
  final SaveAccountUseCase _saveAccountUseCase;
  final SavePasswordUseCase _savePasswordUseCase;
  final GetPasswordUseCase _getPasswordUseCase;
  final ConfirmPasswordUseCase _confirmPasswordUseCase;
  final RegisterUserUseCase _registerUserUseCase;

  String get accountAddress {
    final currentState = state;

    return currentState is AccountLoaded ? currentState.account.address : '';
  }

  String get accountSignature {
    final currentState = state;

    return currentState is AccountLoaded ? currentState.account.signature : '';
  }

  bool get biometricAccess {
    final currentState = state;

    return currentState is AccountLoaded
        ? currentState.account.biometricAccess
        : false;
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

  Future<bool> savePassword(String password) async {
    return await _savePasswordUseCase(password: password);
  }

  Future<bool> authenticateBiometric() async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      final password = await _getPasswordUseCase();

      return await confirmPassword(password!);
    }

    return false;
  }

  Future<void> saveAccount(List<String> mnemonicWords, String password,
      String name, bool useBiometric) async {
    final resultImport = await _importAccountUseCase(
      mnemonic: mnemonicWords.join(' '),
      password: password,
    );

    await resultImport.fold(
      (_) {},
      (importedAcc) async {
        ImportedAccountEntity acc =
            (importedAcc as ImportedAccountModel).copyWith(
          name: name,
          biometricAccess: useBiometric,
        );

        final signature = await _registerUserUseCase(account: acc);

        if (signature != null) {
          acc = (acc as ImportedAccountModel).copyWith(signature: signature);
          emit(AccountLoaded(account: acc));
          await _saveAccountUseCase(keypairJson: json.encode(acc));
        }
      },
    );
  }

  Future<bool> confirmPassword(String password) async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      emit(AccountPasswordValidating(account: currentState.account));

      final confirmationResult = await _confirmPasswordUseCase(
        account: (currentState.account as ImportedAccountModel).toJson(),
        password: password,
      );

      emit(AccountLoaded(account: currentState.account));

      return confirmationResult;
    }

    return false;
  }

  Future<void> switchBiometricAccess() async {
    final currentState = state;

    if (currentState is AccountLoaded) {
      emit(AccountUpdatingBiometric(account: currentState.account));

      ImportedAccountEntity acc = (currentState.account as ImportedAccountModel)
          .copyWith(biometricAccess: !currentState.account.biometricAccess);

      emit(AccountLoaded(account: acc));
      await _saveAccountUseCase(keypairJson: json.encode(acc));
    }

    return;
  }
}
