import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/entities/account_entity.dart';

abstract class IAccountRepository {
  Future<Either<ApiError, Unit>> signUp(String email, String password);
  Future<Either<ApiError, AccountEntity>> confirmSignUp(
    String email,
    String code,
    bool useBiometric,
  );
  Future<Either<ApiError, AccountEntity>> signIn(
    String email,
    String password,
    bool useBiometric,
  );
  Future<Either<ApiError, Unit>> getCurrentUser();
  Future<Either<ApiError, Unit>> resendCode(String email);
  Future<Either<ApiError, Unit>> signOut();
  Future<void> saveAccountStorage(String keypairJson, {String? password});
  Future<AccountEntity?> getAccountStorage();
  Future<void> deleteAccountStorage();
  Future<void> deletePasswordStorage();
  Future<bool> savePasswordStorage(String password);
  Future<String?> getPasswordStorage();
  Future<bool> confirmPassword(String account, String password);
}
