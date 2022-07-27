import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/coin/domain/repositories/icoin_repository.dart';

class WithdrawUseCase {
  WithdrawUseCase({
    required ICoinRepository coinRepository,
  }) : _coinRepository = coinRepository;

  final ICoinRepository _coinRepository;

  Future<Either<ApiError, void>> call({
    required String mainAddress,
    required String proxyAddress,
    required String asset,
    required double amount,
  }) async {
    return await _coinRepository.withdraw(
      mainAddress,
      proxyAddress,
      asset,
      amount,
    );
  }
}
