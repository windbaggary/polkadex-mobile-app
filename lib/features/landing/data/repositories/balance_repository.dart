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
  Future<Either<ApiError, BalanceEntity>> fetchBalance(
    String address,
    String signature,
  ) async {
    try {
      final result = await _balanceRemoteDatasource.fetchBalance(
        address,
        signature,
      );
      final Map<String, dynamic> body = jsonDecode(result.body);

      if (result.statusCode == 200 && body.containsKey('Fine')) {
        return Right(BalanceModel(
          free: body['Fine']['free'],
          used: body['Fine']['used'],
          total: body['Fine']['total'],
        ));
      } else {
        return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }
}
