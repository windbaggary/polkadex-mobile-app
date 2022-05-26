import 'package:dartz/dartz.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/network/error.dart';

abstract class IAssetRepository {
  Future<Either<ApiError, List<AssetEntity>>> getAssetsDetails();
}
