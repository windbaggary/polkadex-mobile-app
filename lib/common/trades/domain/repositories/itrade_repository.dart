import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';

abstract class ITradeRepository {
  Future<Either<ApiError, OrderEntity>> placeOrder(
    String mainAddress,
    String proxyAddress,
    String baseAsset,
    String quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    String price,
    String amount,
  );
  Future<Either<ApiError, String>> cancelOrder(
    int nonce,
    String address,
    String orderId,
  );
  Future<Either<ApiError, List<OrderEntity>>> fetchOrders(
    String address,
    DateTime from,
    DateTime to,
  );
  Future<Either<ApiError, List<AccountTradeEntity>>> fetchAccountTrades(
    String address,
    DateTime from,
    DateTime to,
  );
  Future<Either<ApiError, List<RecentTradeEntity>>> fetchRecentTrades(
      String market);
  Future<void> fetchAccountTradesUpdates(
    String address,
    Function(AccountTradeEntity) onMsgReceived,
    Function(Object) onMsgError,
  );
  Future<void> fetchOrdersUpdates(
    String address,
    Function(OrderEntity) onMsgReceived,
    Function(Object) onMsgError,
  );
}
