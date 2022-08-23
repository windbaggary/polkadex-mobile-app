import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class ResendCodeUseCase {
  ResendCodeUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<Either<ApiError, Unit>> call({required String email}) async {
    return await _accountRepository.resendCode(email);
  }
}