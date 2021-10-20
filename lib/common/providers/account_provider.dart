import 'package:flutter/material.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_storage_usecase.dart';

class AccountProvider extends ChangeNotifier {
  AccountProvider({
    required GetAccountStorageUseCase getAccountStorageUseCase,
  }) : _getAccountStorageUseCase = getAccountStorageUseCase;

  final GetAccountStorageUseCase _getAccountStorageUseCase;

  bool _storeHasAccount = false;

  bool get storeHasAccount => _storeHasAccount;

  Future<void> loadAccountData() async {
    final account = await _getAccountStorageUseCase();

    _storeHasAccount = account != null;
    notifyListeners();
  }
}
