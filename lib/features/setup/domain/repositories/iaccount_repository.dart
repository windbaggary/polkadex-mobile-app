import 'package:dartz/dartz.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

abstract class IAccountRepository {
  Future<void> saveAccountStorage(String keypairJson, {String? password});
  Future<ImportedAccountEntity?> getAccountStorage();
  Future<void> deleteAccountAndPasswordStorage();
  Future<bool> savePasswordStorage(String password);
  Future<String?> getPasswordStorage();
}
