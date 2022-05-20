import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';

abstract class IOrderRepository {
  Future<Either<ApiError, OrderEntity>> placeOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    String price,
    String amount,
    String address,
    String signature,
  );
  Future<Either<ApiError, String>> cancelOrder(
    int nonce,
    String address,
    String orderId,
    String signature,
  );
  Future<Either<ApiError, List<OrderEntity>>> fetchOrders(
    String address,
    String signature,
  );
}
