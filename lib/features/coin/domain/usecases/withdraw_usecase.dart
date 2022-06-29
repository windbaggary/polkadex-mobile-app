import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/coin/domain/repositories/icoin_repository.dart';

class WithdrawUseCase {
  WithdrawUseCase({
    required ICoinRepository coinRepository,
  }) : _coinRepository = coinRepository;

  final ICoinRepository _coinRepository;

  Future<Either<ApiError, String>> call({
    required String asset,
    required double amount,
    required String address,
  }) async {
    return await _coinRepository.withdraw(
      asset,
      amount,
      address,
    );
  }
}
