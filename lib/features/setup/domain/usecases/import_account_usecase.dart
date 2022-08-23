import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/imnemonic_repository.dart';

class ImportAccountUseCase {
  ImportAccountUseCase({
    required IMnemonicRepository mnemonicRepository,
  }) : _mnemonicRepository = mnemonicRepository;

  final IMnemonicRepository _mnemonicRepository;

  Future<Either<ApiError, AccountEntity>> call({
    required String mnemonic,
    required String password,
  }) async {
    return await _mnemonicRepository.importAccount(mnemonic, password);
  }
}
