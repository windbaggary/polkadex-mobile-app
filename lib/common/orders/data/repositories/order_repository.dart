import 'dart:convert';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/data/datasources/order_remote_datasource.dart';
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
        baseAsset == 'PDEX' ? '' : baseAsset,
        quoteAsset == 'PDEX' ? '' : quoteAsset,
        orderType.toString().split('.')[1].capitalize(),
        orderSide == EnumBuySell.buy ? 'Bid' : 'Ask',
        price,
        amount,
        address,
        signature,
      );

      if (result != null) {
        final newOrder = OrderModel(
          orderId: result,
          amount: amount,
          price: price,
          orderSide: orderSide,
          orderType: orderType,
          timestamp: DateTime.now(),
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          status:
              orderType == EnumOrderTypes.market ? 'Filled' : 'PartiallyFilled',
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
  Future<Either<ApiError, List<OrderEntity>>> fetchOrders(
      String address) async {
    try {
      final result = await _orderRemoteDatasource.fetchOrders(address);
      final listTransaction = result.rows.map((row) => row.assoc()).toList();
      List<OrderEntity> listOrder = [];

      for (var transaction in listTransaction) {
        listOrder.add(OrderModel.fromJson(transaction));
      }

      return Right(listOrder);
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, void>> fetcOrdersLiveData(
    String address,
    Function() onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final Consumer? consumer =
        await _orderRemoteDatasource.fetchOrdersConsumer(address);
    try {
      consumer?.listen((message) {
        final payload = message.payloadAsString;
        message.ack();
        print(payload);

        onMsgReceived();
      });
    } catch (error) {
      onMsgError(error);
    }

    if (consumer != null) {
      return Right(null);
    } else {
      return Left(ApiError(
          message: 'Connection error while trying to fetch orders data.'));
    }
  }
}
