import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/imnemonic_repository.dart';

class MnemonicRepository implements IMnemonicRepository {
  MnemonicRepository(
      {required MnemonicRemoteDatasource mnemonicRemoteDatasource})
      : _mnemonicRemoteDatasource = mnemonicRemoteDatasource;

  final MnemonicRemoteDatasource _mnemonicRemoteDatasource;

  @override
  Future<Either<ApiError, List<String>>> generateMnemonic() async {
    final result = await _mnemonicRemoteDatasource.generateMnemonic();

    if (result['mnemonic'] != null) {
      return Right(result['mnemonic'].split(' '));
    } else {
      return Left(ApiError(message: ''));
    }
  }

  @override
  Future<Either<ApiError, AccountEntity>> importAccount(
      String mnemonic, String password) async {
    final result = await _mnemonicRemoteDatasource.importAccount(
        mnemonic, password.toBase64());

    if (result['error'] == null) {
      return Right(AccountModel.fromJson(result));
    } else {
      return Left(ApiError.fromJson(result['error']));
    }
  }
}
