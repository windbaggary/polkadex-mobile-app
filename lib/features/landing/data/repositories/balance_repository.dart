import 'dart:convert';
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

      return Right(BalanceModel.fromJson(
          result.data?['getAllBalancesByMainAccount']['items']));
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<void> fetchBalanceLiveData(
    String address,
    Function(BalanceEntity) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final Stream balanceStream =
        await _balanceRemoteDatasource.fetchBalanceStream(address);
    try {
      balanceStream.listen((message) {
        final payload = message.payloadAsString;
        message.ack();

        final liveDataJson = json.decode(payload);

        onMsgReceived(BalanceModel.fromLiveJson(liveDataJson));
      });
    } catch (error) {
      onMsgError(error);
    }
  }
}
