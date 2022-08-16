import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/features/setup/data/datasources/account_local_datasource.dart';
import 'package:polkadex/features/setup/data/datasources/account_remote_datasource.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class AccountRepository implements IAccountRepository {
  AccountRepository({
    required AccountRemoteDatasource accountRemoteDatasource,
    required AccountLocalDatasource accountLocalDatasource,
  })  : _accountRemoteDatasource = accountRemoteDatasource,
        _accountLocalDatasource = accountLocalDatasource;

  final AccountRemoteDatasource _accountRemoteDatasource;
  final AccountLocalDatasource _accountLocalDatasource;

  @override
  Future<Either<ApiError, Unit>> signUp(
    String email,
    String password,
  ) async {
    try {
      await _accountRemoteDatasource.signUp(email, password);

      return Right(unit);
    } catch (e) {
      return Left(
        ApiError(
          message: e.toString(),
        ),
      );
    }
  }

  @override
  Future<Either<ApiError, Unit>> confirmSignUp(
    String email,
    String code,
  ) async {
    try {
      await _accountRemoteDatasource.confirmSignUp(email, code);

      return Right(unit);
    } catch (e) {
      return Left(
        ApiError(
          message: e.toString(),
        ),
      );
    }
  }

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
  Future<void> deleteAccountStorage() async {
    return await _accountLocalDatasource.deleteAccountStorage();
  }

  @override
  Future<void> deletePasswordStorage() async {
    return await _accountLocalDatasource.deletePasswordStorage();
  }

  @override
  Future<bool> savePasswordStorage(String password) async {
    return await _accountLocalDatasource.savePasswordStorage(password);
  }

  @override
  Future<String?> getPasswordStorage() async {
    return await _accountLocalDatasource.getPasswordStorage();
  }

  @override
  Future<bool> confirmPassword(
      Map<String, dynamic> account, String password) async {
    return await _accountLocalDatasource.confirmPassword(
        account, password.toBase64());
  }

  @override
  Future<String?> register(String address) async {
    final result = await _accountLocalDatasource.registerUser(address);

    return result['signature'];
  }
}
