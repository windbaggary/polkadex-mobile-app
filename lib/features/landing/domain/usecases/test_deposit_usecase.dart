import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';

class TestDepositUseCase {
  TestDepositUseCase({
    required IBalanceRepository balanceRepository,
  }) : _balanceRepository = balanceRepository;

  final IBalanceRepository _balanceRepository;

  Future<Either<ApiError, String>> call({
    required int asset,
    required String address,
    required String signature,
  }) async {
    return await _balanceRepository.testDeposit(
      asset,
      address,
      signature,
    );
  }
}
