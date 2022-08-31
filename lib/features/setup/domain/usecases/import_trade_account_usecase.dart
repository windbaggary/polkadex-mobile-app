import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/imnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/entities/imported_trade_account_entity.dart';

class ImportTradeAccountUseCase {
  ImportTradeAccountUseCase({
    required IMnemonicRepository mnemonicRepository,
  }) : _mnemonicRepository = mnemonicRepository;

  final IMnemonicRepository _mnemonicRepository;

  Future<Either<ApiError, ImportedTradeAccountEntity>> call({
    required String mnemonic,
    required String password,
  }) async {
    return await _mnemonicRepository.importTradeAccount(mnemonic, password);
  }
}
