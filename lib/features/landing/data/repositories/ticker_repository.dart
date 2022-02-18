import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/datasources/ticker_remote_datasource.dart';
import 'package:polkadex/features/landing/data/models/ticker_model.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iticker_repository.dart';

class TickerRepository implements ITickerRepository {
  TickerRepository({required TickerRemoteDatasource tickerRemoteDatasource})
      : _tickerRemoteDatasource = tickerRemoteDatasource;

  final TickerRemoteDatasource _tickerRemoteDatasource;

  @override
  Future<Either<ApiError, TickerEntity>> getLastTicker(
    String leftTokenId,
    String rightTokenId,
  ) async {
    try {
      final result = await _tickerRemoteDatasource.getLastTickerData(
        leftTokenId,
        rightTokenId,
      );
      final Map<String, dynamic> body = jsonDecode(result.body);
      final Map<String, dynamic> fineBody = jsonDecode(body['Fine']);

      if (result.statusCode == 200 && body.containsKey('Fine')) {
        return Right(TickerModel.fromJson(fineBody));
      } else {
        return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }
}
