import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/datasources/order_remote_datasource.dart';
import 'package:polkadex/features/landing/data/models/order_model.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iorder_repository.dart';

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
      return Right(OrderModel(
        //uuid will be a random string since we are working with mocks for now
        uuid: UniqueKey().toString(),
        type: orderSide,
        amount: quantity.toString(),
        price: price.toString(),
        dateTime: DateTime.now(),
        amountCoin: baseAsset,
        priceCoin: quoteAsset,
        orderType: orderType,
        tokenPairName: '$baseAsset/$quoteAsset',
      ));
    } else {
      return Left(ApiError(message: result['message']));
    }
  }

  @override
  Future<Either<ApiError, String>> cancelOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    String orderUuid,
  ) async {
    final result = await _orderRemoteDatasource.cancelOrder(
      nonce,
      baseAsset,
      quoteAsset,
      orderUuid,
    );

    if (result['success']) {
      return Right(result['message']);
    } else {
      return Left(ApiError(message: result['message']));
    }
  }
}
