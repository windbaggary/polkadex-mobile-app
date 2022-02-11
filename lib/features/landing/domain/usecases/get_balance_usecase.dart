import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';

class GetBalanceUseCase {
  GetBalanceUseCase({
    required IBalanceRepository balanceRepository,
  }) : _balanceRepository = balanceRepository;

  final IBalanceRepository _balanceRepository;

  Future<Either<ApiError, BalanceEntity>> call(
      {required String address, required String signature}) async {
    return await _balanceRepository.fetchBalance(address, signature);
  }
}
