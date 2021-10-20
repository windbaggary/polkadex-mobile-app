import 'package:flutter/material.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_and_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';

class AccountProvider extends ChangeNotifier {
  AccountProvider({
    required GetAccountUseCase getAccountStorageUseCase,
    required DeleteAccountAndPasswordUseCase deleteAccountAndPasswordUseCase,
  })  : _getAccountStorageUseCase = getAccountStorageUseCase,
        _deleteAccountAndPasswordUseCase = deleteAccountAndPasswordUseCase;

  final GetAccountUseCase _getAccountStorageUseCase;
  final DeleteAccountAndPasswordUseCase _deleteAccountAndPasswordUseCase;

  bool _storeHasAccount = false;

  bool get storeHasAccount => _storeHasAccount;

  Future<void> loadAccountData() async {
    final account = await _getAccountStorageUseCase();

    _storeHasAccount = account != null;
    notifyListeners();
  }

  Future<void> logout() async {
    return await _deleteAccountAndPasswordUseCase();
  }
}
