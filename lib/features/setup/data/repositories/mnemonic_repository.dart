import 'package:dartz/dartz.dart';
import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';

class MnemonicRepository {
  MnemonicRepository(
      {required MnemonicRemoteDatasource mnemonicRemoteDatasource})
      : _mnemonicRemoteDatasource = mnemonicRemoteDatasource;

  final MnemonicRemoteDatasource _mnemonicRemoteDatasource;

  Future<Either<Error, List<String>>> generateMnemonic() async {
    final result = await _mnemonicRemoteDatasource.generateMnemonic();

    if (result['mnemonic'] != null) {
      return Right(result['mnemonic'].split(' '));
    } else {
      return Left(Error());
    }
  }
}
