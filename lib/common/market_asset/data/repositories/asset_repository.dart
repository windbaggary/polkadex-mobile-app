import 'package:dartz/dartz.dart';
import 'package:polkadex/common/market_asset/data/models/asset_model.dart';
import 'package:polkadex/common/market_asset/domain/repositories/iasset_repository.dart';
import 'package:polkadex/common/market_asset/data/datasources/asset_remote_datasource.dart';
import 'package:polkadex/common/network/error.dart';

class AssetRepository implements IAssetRepository {
  AssetRepository({required AssetRemoteDatasource assetRemoteDatasource})
      : _assetRemoteDatasource = assetRemoteDatasource;

  final AssetRemoteDatasource _assetRemoteDatasource;

  @override
  Future<Either<ApiError, List<AssetModel>>> getAssetsDetails() async {
    try {
      final resultFetch = await _assetRemoteDatasource.getAssetsDetails();
      if (resultFetch.isNotEmpty) {
        return Right(
            resultFetch.map((asset) => AssetModel.fromJson(asset)).toList());
      } else {
        return Left(
          ApiError(
              message:
                  'No Assets fetched from the blockchain. Please try again'),
        );
      }
    } catch (_) {
      return Left(
        ApiError(
            message:
                'Failed to fetch asset data from blockchain. Please try again'),
      );
    }
  }
}
