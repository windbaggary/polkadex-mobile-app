import 'package:dartz/dartz.dart';
import 'package:polkadex/common/market_asset/data/models/market_model.dart';
import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';
import 'package:polkadex/common/market_asset/domain/repositories/imarket_repository.dart';
import 'package:polkadex/common/market_asset/data/datasources/market_remote_datasource.dart';
import 'package:polkadex/common/network/error.dart';

class MarketRepository implements IMarketRepository {
  MarketRepository({required MarketRemoteDatasource marketRemoteDatasource})
      : _marketRemoteDatasource = marketRemoteDatasource;

  final MarketRemoteDatasource _marketRemoteDatasource;

  @override
  Future<Either<ApiError, List<MarketEntity>>> getMarkets() async {
    try {
      final resultFetch = await _marketRemoteDatasource.getMarkets();

      if (resultFetch.isNotEmpty) {
        return Right(
            resultFetch.map((market) => MarketModel.fromJson(market)).toList());
      } else {
        return Left(
          ApiError(
              message:
                  'No markets fetched from the blockchain. Please try again'),
        );
      }
    } catch (_) {
      return Left(
        ApiError(
            message:
                'Failed to fetch market data from blockchain. Please try again'),
      );
    }
  }
}
