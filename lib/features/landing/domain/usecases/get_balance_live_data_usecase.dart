import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';

class GetBalanceLiveDataUseCase {
  GetBalanceLiveDataUseCase({
    required IBalanceRepository balanceRepository,
  }) : _balanceRepository = balanceRepository;

  final IBalanceRepository _balanceRepository;

  Future<Either<ApiError, void>> call({
    required Function() onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _balanceRepository.fetchBalanceLiveData(
      onMsgReceived,
      onMsgError,
    );
  }
}
