import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class CancelOrderUseCase {
  CancelOrderUseCase({
    required ITradeRepository tradeRepository,
  }) : _tradeRepository = tradeRepository;

  final ITradeRepository _tradeRepository;

  Future<Either<ApiError, void>> call({
    required String address,
    required String baseAsset,
    required String quoteAsset,
    required String orderId,
  }) async {
    return await _tradeRepository.cancelOrder(
      address,
      baseAsset,
      quoteAsset,
      orderId,
    );
  }
}
