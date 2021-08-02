import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

class ImportAccountUseCase {
  ImportAccountUseCase({
    required MnemonicRepository mnemonicRepository,
  }) : _mnemonicRepository = mnemonicRepository;

  final MnemonicRepository _mnemonicRepository;

  Future<Either<ApiError, ImportedAccountEntity>> call({
    required String mnemonic,
    required String password,
  }) async {
    return await _mnemonicRepository.importAccount(mnemonic, password);
  }
}
