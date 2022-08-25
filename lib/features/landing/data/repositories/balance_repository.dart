import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/user_data/user_data_remote_datasource.dart';
import 'package:polkadex/features/landing/data/datasources/balance_remote_datasource.dart';
import 'package:polkadex/features/landing/data/models/balance_model.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';

class BalanceRepository implements IBalanceRepository {
  BalanceRepository({
    required BalanceRemoteDatasource balanceRemoteDatasource,
    required UserDataRemoteDatasource userDataRemoteDatasource,
  })  : _balanceRemoteDatasource = balanceRemoteDatasource,
        _userDataRemoteDatasource = userDataRemoteDatasource;

  final BalanceRemoteDatasource _balanceRemoteDatasource;
  final UserDataRemoteDatasource _userDataRemoteDatasource;

  @override
  Future<Either<ApiError, BalanceEntity>> fetchBalance(String address) async {
    try {
      final result = await _balanceRemoteDatasource.fetchBalance(address);

      return Right(
        BalanceModel.fromJson(
          jsonDecode(result.data)['getAllBalancesByMainAccount']['items'],
        ),
      );
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<void> fetchBalanceUpdates(
    String address,
    Function(BalanceEntity) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final Stream balanceStream =
        await _userDataRemoteDatasource.getUserDataStream(address);
    try {
      balanceStream.listen((message) {
        final data = message.data;

        if (data != null) {
          final liveData =
              jsonDecode(jsonDecode(data)['websocket_streams']['data']);
          final newBalanceData = liveData['SetBalance'];

          if (newBalanceData != null) {
            onMsgReceived(
              BalanceModel.fromUpdateJson(
                [newBalanceData],
              ),
            );
          }
        }
      });
    } catch (error) {
      onMsgError(error);
    }
  }
}
