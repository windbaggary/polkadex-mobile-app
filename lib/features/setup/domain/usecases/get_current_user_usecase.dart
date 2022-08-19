import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class GetCurrentUserUseCase {
  GetCurrentUserUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<Either<ApiError, Unit>> call() async {
    return await _accountRepository.getCurrentUser();
  }
}
