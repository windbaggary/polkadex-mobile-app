import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/coin/data/datasources/coin_remote_datasource.dart';
import 'package:polkadex/features/coin/domain/repositories/icoin_repository.dart';

class CoinRepository implements ICoinRepository {
  CoinRepository({required CoinRemoteDatasource coinRemoteDatasource})
      : _coinRemoteDatasource = coinRemoteDatasource;

  final CoinRemoteDatasource _coinRemoteDatasource;

  @override
  Future<Either<ApiError, String>> withdraw(
    String asset,
    double amount,
    String address,
    String signature,
  ) async {
    try {
      final result = await _coinRemoteDatasource.withdraw(
        asset,
        amount,
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
