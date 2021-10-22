import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class GetPasswordUseCase {
  GetPasswordUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<String?> call() async {
    return await _accountRepository.getPasswordStorage();
  }
}
