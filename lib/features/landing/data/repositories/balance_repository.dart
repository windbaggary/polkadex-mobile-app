import 'dart:convert';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/datasources/balance_remote_datasource.dart';
import 'package:polkadex/features/landing/data/models/balance_model.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';

class BalanceRepository implements IBalanceRepository {
  BalanceRepository({required BalanceRemoteDatasource balanceRemoteDatasource})
      : _balanceRemoteDatasource = balanceRemoteDatasource;

  final BalanceRemoteDatasource _balanceRemoteDatasource;

  @override
  Future<Either<ApiError, BalanceEntity>> fetchBalance(String address) async {
    try {
      final result = await _balanceRemoteDatasource.fetchBalance(address);

      return Right(BalanceModel.fromResultSet(result));
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<Either<ApiError, void>> fetchBalanceLiveData(
    String address,
    Function(BalanceEntity) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final Consumer? consumer =
        await _balanceRemoteDatasource.fetchBalanceConsumer(address);
    try {
      consumer?.listen((message) {
        final payload = message.payloadAsString;
        message.ack();

        final liveDataJson = json.decode(payload);

        onMsgReceived(BalanceModel.fromLiveJson(liveDataJson));
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

  @override
  Future<Either<ApiError, String>> testDeposit(
    int asset,
    String address,
    String signature,
  ) async {
    try {
      final result = await _balanceRemoteDatasource.testDeposit(
        asset,
        address,
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
}
