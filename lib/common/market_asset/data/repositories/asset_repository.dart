import 'package:dartz/dartz.dart';
import 'package:polkadex/common/market_asset/domain/repositories/iasset_repository.dart';
import 'package:polkadex/common/market_asset/data/datasources/asset_remote_datasource.dart';
import 'package:polkadex/common/network/error.dart';

class AssetRepository implements IAssetRepository {
  AssetRepository({required AssetRemoteDatasource assetRemoteDatasource})
      : _assetRemoteDatasource = assetRemoteDatasource;

  final AssetRemoteDatasource _assetRemoteDatasource;

  @override
  Future<Either<ApiError, List<Map<String, dynamic>>?>>
      getAssetsDetails() async {
    try {
      return Right(await _assetRemoteDatasource.getAssetsDetails());
    } catch (_) {
      return Left(
        ApiError(
            message:
                'Failed to fetch asset data from blockchain. Please try again'),
      );
    }
  }
}
