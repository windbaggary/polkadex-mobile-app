import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class RegisterUserUseCase {
  RegisterUserUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<bool> call({required Map<String, dynamic> account}) async {
    return await _accountRepository.register(account);
  }
}
