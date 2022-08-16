import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

abstract class IAccountRepository {
  Future<Either<ApiError, Unit>> signUp(String email, String password);
  Future<Either<ApiError, Unit>> confirmSignUp(
    String email,
    String code,
  );
  Future<void> saveAccountStorage(String keypairJson, {String? password});
  Future<ImportedAccountEntity?> getAccountStorage();
  Future<void> deleteAccountStorage();
  Future<void> deletePasswordStorage();
  Future<bool> savePasswordStorage(String password);
  Future<String?> getPasswordStorage();
  Future<bool> confirmPassword(Map<String, dynamic> account, String password);
  Future<String?> register(String address);
}
