import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class SignInUseCase {
  SignInUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<Either<ApiError, Unit>> call({
    required String email,
    required String password,
  }) async {
    return await _accountRepository.signIn(email, password);
  }
}
