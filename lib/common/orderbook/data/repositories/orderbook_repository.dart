import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orderbook/data/datasources/orderbook_remote_datasource.dart';
import 'package:polkadex/common/orderbook/data/models/orderbook_model.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';
import 'package:polkadex/common/orderbook/domain/repositories/iorderbook_repository.dart';

class OrderbookRepository implements IOrderbookRepository {
  OrderbookRepository(
      {required OrderbookRemoteDatasource orderbookRemoteDatasource})
      : _orderbookRemoteDatasource = orderbookRemoteDatasource;

  final OrderbookRemoteDatasource _orderbookRemoteDatasource;

  @override
  Future<Either<ApiError, OrderbookEntity>> getOrderbookData(
    String leftTokenId,
    String rightTokenId,
  ) async {
    try {
      final result = await _orderbookRemoteDatasource.getOrderbookData(
        leftTokenId,
        rightTokenId,
      );

      return Right(
        OrderbookModel.fromJson(
          jsonDecode(result.data)['getOrderbook']['items'],
        ),
      );
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, void>> getOrderbookLiveData(
    String leftTokenId,
    String rightTokenId,
    Function(OrderbookEntity) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final Consumer? consumer =
        await _orderbookRemoteDatasource.getOrderbookConsumer(
      leftTokenId,
      rightTokenId,
    );
    try {
      consumer?.listen((message) {
        final payload = message.payloadAsString;
        message.ack();

        onMsgReceived(OrderbookModel.fromJson(json.decode(payload)));
      });
    } catch (error) {
      onMsgError(error);
    }

    if (consumer != null) {
      return Right(null);
    } else {
      return Left(ApiError(
          message: 'Connection error while trying to fetch orderbook data.'));
    }
  }
}
