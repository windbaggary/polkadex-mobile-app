import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class DeleteAccountAndPasswordUseCase {
  DeleteAccountAndPasswordUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<void> call() async {
    return await _accountRepository.deleteAccountAndPasswordStorage();
  }
}
