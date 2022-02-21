import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class RegisterUserUseCase {
  RegisterUserUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<String?> call({required String address}) async {
    return await _accountRepository.register(address);
  }
}
