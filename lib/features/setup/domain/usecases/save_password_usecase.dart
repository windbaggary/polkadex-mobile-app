import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class SavePasswordUseCase {
  SavePasswordUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<bool> call({
    required String password,
  }) async {
    return await _accountRepository.savePasswordStorage(password);
  }
}
