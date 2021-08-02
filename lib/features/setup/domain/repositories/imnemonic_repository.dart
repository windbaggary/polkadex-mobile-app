import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

abstract class IMnemonicRepository {
  Future<Either<ApiError, List<String>>> generateMnemonic();
  Future<Either<ApiError, ImportedAccountEntity>> importAccount(
      String mnemonic, String password);
}
