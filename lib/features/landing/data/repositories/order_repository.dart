import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/datasources/order_remote_datasource.dart';
import 'package:polkadex/features/landing/domain/repositories/iorder_repository.dart';

class OrderRepository implements IOrderRepository {
  OrderRepository({required OrderRemoteDatasource orderRemoteDatasource})
      : _orderRemoteDatasource = orderRemoteDatasource;

  final OrderRemoteDatasource _orderRemoteDatasource;

  @override
  Future<Either<ApiError, String>> placeOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    double price,
    double quantity,
  ) async {
    final result = await _orderRemoteDatasource.placeOrder(
      nonce,
      baseAsset,
      quoteAsset,
      orderType,
      orderSide,
      price,
      quantity,
    );

    if (result['success']) {
      return Right(result['message']);
    } else {
      return Left(ApiError(message: result['message']));
    }
  }
}
