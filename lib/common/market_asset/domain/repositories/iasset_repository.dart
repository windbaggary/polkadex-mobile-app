import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/market_asset/data/models/asset_model.dart';

abstract class IAssetRepository {
  Future<Either<ApiError, List<AssetModel>>> getAssetsDetails();
}
