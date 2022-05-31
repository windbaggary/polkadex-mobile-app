import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';

abstract class IMarketRepository {
  Future<Either<ApiError, List<MarketEntity>>> getMarkets();
}
