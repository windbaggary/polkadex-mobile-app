import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_and_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';

part 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit({
    required GetAccountUseCase getAccountStorageUseCase,
    required DeleteAccountAndPasswordUseCase deleteAccountAndPasswordUseCase,
    required ImportAccountUseCase importAccountUseCase,
    required SaveAccountUseCase saveAccountUseCase,
    required SavePasswordUseCase savePasswordUseCase,
    required GetPasswordUseCase getPasswordUseCase,
    required ConfirmPasswordUseCase confirmPasswordUseCase,
  })  : _getAccountStorageUseCase = getAccountStorageUseCase,
        _deleteAccountAndPasswordUseCase = deleteAccountAndPasswordUseCase,
        _importAccountUseCase = importAccountUseCase,
        _saveAccountUseCase = saveAccountUseCase,
        _savePasswordUseCase = savePasswordUseCase,
        _getPasswordUseCase = getPasswordUseCase,
        _confirmPasswordUseCase = confirmPasswordUseCase,
        super(AccountInitial());

  final GetAccountUseCase _getAccountStorageUseCase;
  final DeleteAccountAndPasswordUseCase _deleteAccountAndPasswordUseCase;
  final ImportAccountUseCase _importAccountUseCase;
  final SaveAccountUseCase _saveAccountUseCase;
  final SavePasswordUseCase _savePasswordUseCase;
  final GetPasswordUseCase _getPasswordUseCase;
  final ConfirmPasswordUseCase _confirmPasswordUseCase;

  Future<void> loadAccountData() async {
    final account = await _getAccountStorageUseCase();

    account != null
        ? emit(AccountLoaded(account: account))
        : emit(AccountNotLoaded());
  }

  Future<void> logout() async {
    return await _deleteAccountAndPasswordUseCase();
  }

  Future<bool> savePassword(String password) async {
    return await _savePasswordUseCase(password: password);
  }

  Future<bool> authenticateBiometric() async {
    final result = await _getPasswordUseCase();

    return result != null;
  }

  Future<void> saveAccount(List<String> mnemonicWords, String password,
      String name, bool useBiometric) async {
    final result = await _importAccountUseCase(
      mnemonic: mnemonicWords.join(' '),
      password: password,
    );

    result.fold(
      (_) {},
      (importedAcc) async {
        final acc = (importedAcc as ImportedAccountModel).copyWith(
          name: name,
          biometricAccess: useBiometric,
        );

        emit(AccountLoaded(account: acc));

        await _saveAccountUseCase(keypairJson: json.encode(acc));
      },
    );
  }

  Future<bool> confirmPassword(
      Map<String, dynamic> account, String password) async {
    return await _confirmPasswordUseCase(account: account, password: password);
  }
}
