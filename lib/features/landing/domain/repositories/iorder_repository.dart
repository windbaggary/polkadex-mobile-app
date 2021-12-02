import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';

abstract class IOrderRepository {
  Future<Either<ApiError, OrderEntity>> placeOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    double price,
    double quantity,
  );
  Future<Either<ApiError, String>> cancelOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    String orderUuid,
    String signature,
  );
  Future<Either<ApiError, List<OrderEntity>>> fetchOpenOrders(
    String address,
    String signature,
  );
}
