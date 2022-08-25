import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';

class ConfirmSignUpUseCase {
  ConfirmSignUpUseCase({
    required IAccountRepository accountRepository,
  }) : _accountRepository = accountRepository;

  final IAccountRepository _accountRepository;

  Future<Either<ApiError, AccountEntity>> call({
    required String email,
    required String code,
    required bool useBiometric,
  }) async {
    return await _accountRepository.confirmSignUp(
      email,
      code,
      useBiometric,
    );
  }
}
