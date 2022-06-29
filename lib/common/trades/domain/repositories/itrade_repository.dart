import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';

abstract class ITradeRepository {
  Future<Either<ApiError, OrderEntity>> placeOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    String price,
    String amount,
    String address,
  );
  Future<Either<ApiError, String>> cancelOrder(
    int nonce,
    String address,
    String orderId,
  );
  Future<Either<ApiError, List<OrderEntity>>> fetchOrders(String address);

  Future<Either<ApiError, List<TradeEntity>>> fetchTrades(String address);
}
