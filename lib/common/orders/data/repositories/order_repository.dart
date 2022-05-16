import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/data/datasources/order_remote_datasource.dart';
import 'package:polkadex/common/orders/data/models/fee_model.dart';
import 'package:polkadex/common/orders/data/models/order_model.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/orders/domain/repositories/iorder_repository.dart';
import 'package:polkadex/common/utils/extensions.dart';

class OrderRepository implements IOrderRepository {
  OrderRepository({required OrderRemoteDatasource orderRemoteDatasource})
      : _orderRemoteDatasource = orderRemoteDatasource;

  final OrderRemoteDatasource _orderRemoteDatasource;

  @override
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
  ) async {
    try {
      final result = await _orderRemoteDatasource.placeOrder(
        nonce,
        int.parse(baseAsset),
        int.parse(quoteAsset),
        orderType.toString().split('.')[1].capitalize(),
        orderSide == EnumBuySell.buy ? 'Bid' : 'Ask',
        price,
        amount,
        address,
        signature,
      );

      if (result != null) {
        final newOrder = OrderModel(
          orderId: result.toString(),
          mainAcc: address,
          amount: amount,
          price: price,
          orderSide: orderSide,
          orderType: orderType,
          timestamp: DateTime.now(),
          baseAsset: baseAsset.toString(),
          quoteAsset: quoteAsset.toString(),
          status: orderType == EnumOrderTypes.market ? 'Closed' : 'Open',
          filledQty: orderType == EnumOrderTypes.market ? amount : '0.0',
          fee: FeeModel(currency: baseAsset.toString(), cost: '0'),
          trades: [],
        );

        return Right(newOrder);
      } else {
        return Left(
            ApiError(message: 'Error on JSON RPC request. Please try again.'));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, String>> cancelOrder(
    int nonce,
    String address,
    String orderId,
    String signature,
  ) async {
    try {
      final result = await _orderRemoteDatasource.cancelOrder(
        nonce,
        address,
        int.parse(orderId),
        signature,
      );
      final Map<String, dynamic> body = jsonDecode(result.body);

      if (result.statusCode == 200 && body.containsKey('Fine')) {
        return Right(body['Fine']);
      } else {
        return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, List<OrderEntity>>> fetchOpenOrders(
    String address,
    String signature,
  ) async {
    try {
      final result = await _orderRemoteDatasource.fetchOpenOrders(
        address,
        signature,
      );
      final Map<String, dynamic> body = jsonDecode(result.body);

      if (result.statusCode == 200 && body.containsKey('Fine')) {
        final orderList = (body['Fine'] as List)
            .reversed
            .map((dynamic json) => OrderModel.fromJson(json))
            .toList();

        orderList.removeWhere((order) =>
            order.orderType == EnumOrderTypes.market && order.status == 'Open');

        return Right(orderList);
      } else {
        return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, List<OrderEntity>>> fetchOrders(
    String address,
    String signature,
  ) async {
    try {
      final result = await _orderRemoteDatasource.fetchOrders(
        address,
        signature,
      );
      final Map<String, dynamic> body = jsonDecode(result.body);

      if (result.statusCode == 200 && body.containsKey('Fine')) {
        final orderList = (body['Fine'] as List)
            .map((dynamic json) => OrderModel.fromJson(json))
            .toList();

        return Right(orderList);
      } else {
        return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }
}
