import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class SaveAccountStorageUseCase {
  SaveAccountStorageUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<void> call({
    required String keypairJson,
    String? password,
  }) async {
    return await _accountRepository.saveAccountStorage(keypairJson,
        password: password);
  }
}
