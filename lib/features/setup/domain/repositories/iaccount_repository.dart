import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

abstract class IAccountRepository {
  Future<Either<ApiError, Unit>> signUp(String email, String password);
  Future<Either<ApiError, ImportedAccountEntity>> confirmSignUp(
    String email,
    String code,
    bool useBiometric,
  );
  Future<Either<ApiError, ImportedAccountEntity>> signIn(
    String email,
    String password,
    bool useBiometric,
  );
  Future<Either<ApiError, AuthUser>> getCurrentUser();
  Future<Either<ApiError, Unit>> signOut();
  Future<void> saveAccountStorage(String keypairJson, {String? password});
  Future<ImportedAccountEntity?> getAccountStorage();
  Future<void> deleteAccountStorage();
  Future<void> deletePasswordStorage();
  Future<bool> savePasswordStorage(String password);
  Future<String?> getPasswordStorage();
  Future<bool> confirmPassword(Map<String, dynamic> account, String password);
}
