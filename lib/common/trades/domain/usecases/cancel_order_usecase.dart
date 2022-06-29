import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class CancelOrderUseCase {
  CancelOrderUseCase({
    required ITradeRepository tradeRepository,
  }) : _tradeRepository = tradeRepository;

  final ITradeRepository _tradeRepository;

  Future<Either<ApiError, String>> call({
    required int nonce,
    required String address,
    required String orderId,
  }) async {
    return await _tradeRepository.cancelOrder(
      nonce,
      address,
      orderId,
    );
  }
}
