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
      final listBalance = result.rows.map((row) => row.assoc()).toList();

      final mapFree = {};
      final mapUsed = {};
      final mapTotal = {};

      for (var assetMap in listBalance) {
        mapFree[assetMap['asset_type']] = assetMap['free_balance'];
      }

      return Right(BalanceModel(
        free: mapFree,
        used: mapUsed,
        total: mapTotal,
      ));
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
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
