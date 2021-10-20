import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class GetAccountStorageUseCase {
  GetAccountStorageUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<ImportedAccountEntity?> call() async {
    return await _accountRepository.getAccountStorage();
  }
}
