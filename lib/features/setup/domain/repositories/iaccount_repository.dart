import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

abstract class IAccountRepository {
  Future<void> saveAccountStorage(String keypairJson, {String? password});
  Future<ImportedAccountEntity?> getAccountStorage();
  Future<void> deleteAccountAndPasswordStorage();
  Future<bool> savePasswordStorage(String password);
  Future<String?> getPasswordStorage();
  Future<bool> confirmPassword(Map<String, dynamic> account, String password);
  Future<String?> register(ImportedAccountEntity account);
}
