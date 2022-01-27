import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
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
    String address,
    String signature,
  ) async {
    try {
      final result = await _orderRemoteDatasource.placeOrder(
        nonce,
        baseAsset,
        quoteAsset,
        orderType,
        orderSide,
        price,
        quantity,
        address,
        signature,
      );
      final newOrder = OrderModel(
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
      );
      final Map<String, dynamic> body = jsonDecode(result.body);

      if (result.statusCode == 200 && body.containsKey('FineWithMessage')) {
        return Right(newOrder);
      } else {
        return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, String>> cancelOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    String orderUuid,
    String signature,
  ) async {
    try {
      final result = await _orderRemoteDatasource.cancelOrder(
        nonce,
        baseAsset,
        quoteAsset,
        orderUuid,
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
