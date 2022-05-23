import 'package:dartz/dartz.dart';
import 'package:polkadex/common/market_asset/domain/repositories/imarket_repository.dart';
import 'package:polkadex/common/market_asset/data/datasources/market_remote_datasource.dart';
import 'package:polkadex/common/network/error.dart';

class MarketRepository implements IMarketRepository {
  MarketRepository({required MarketRemoteDatasource marketRemoteDatasource})
      : _marketRemoteDatasource = marketRemoteDatasource;

  final MarketRemoteDatasource _marketRemoteDatasource;

  @override
  Future<Either<ApiError, List<Map<String, dynamic>>?>> getMarkets() async {
    try {
      return Right(await _marketRemoteDatasource.getMarkets());
    } catch (_) {
      return Left(
        ApiError(
            message:
                'Failed to fetch market data from blockchain. Please try again'),
      );
    }
  }
}
