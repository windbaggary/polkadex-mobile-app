import 'package:polkadex/features/setup/domain/entities/account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class GetAccountUseCase {
  GetAccountUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<AccountEntity?> call() async {
    return await _accountRepository.getAccountStorage();
  }
}
