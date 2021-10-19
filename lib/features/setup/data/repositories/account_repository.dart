import 'package:polkadex/features/setup/data/datasources/account_local_datasource.dart';
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
}
