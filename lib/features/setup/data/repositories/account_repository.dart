import 'dart:convert';

import 'package:polkadex/features/setup/data/datasources/account_local_datasource.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class AccountRepository implements IAccountRepository {
  AccountRepository({required AccountLocalDatasource accountLocalDatasource})
      : _accountLocalDatasource = accountLocalDatasource;

  final AccountLocalDatasource _accountLocalDatasource;

  @override
  Future<void> saveAccountStorage(String keypairJson,
      {String? password}) async {
    return await _accountLocalDatasource.saveAccountStorage(keypairJson,
        password: password);
  }

  @override
  Future<ImportedAccountEntity?> getAccountStorage() async {
    final result = await _accountLocalDatasource.getAccountStorage();

    return result != null
        ? ImportedAccountModel.fromJson(jsonDecode(result))
        : null;
  }

  @override
  Future<void> deleteAccountAndPasswordStorage() async {
    return await _accountLocalDatasource.deleteAccountAndPasswordStorage();
  }

  @override
  Future<bool> savePasswordStorage(String password) async {
    return await _accountLocalDatasource.savePasswordStorage(password);
  }
}
