import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class ConfirmPasswordUseCase {
  ConfirmPasswordUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<bool> call({
    required Map<String, dynamic> account,
    required String password,
  }) async {
    return await _accountRepository.confirmPassword(account, password);
  }
}
