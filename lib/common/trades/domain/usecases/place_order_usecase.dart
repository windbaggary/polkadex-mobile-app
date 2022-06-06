import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class PlaceOrderUseCase {
  PlaceOrderUseCase({
    required ITradeRepository tradeRepository,
  }) : _tradeRepository = tradeRepository;

  final ITradeRepository _tradeRepository;

  Future<Either<ApiError, OrderEntity>> call({
    required int nonce,
    required String baseAsset,
    required String quoteAsset,
    required EnumOrderTypes orderType,
    required EnumBuySell orderSide,
    required String price,
    required String amount,
    required String address,
    required String signature,
  }) async {
    return await _tradeRepository.placeOrder(
      nonce,
      baseAsset,
      quoteAsset,
      orderType,
      orderSide,
      price,
      amount,
      address,
      signature,
    );
  }
}
