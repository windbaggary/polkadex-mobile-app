import 'package:dartz/dartz.dart';
import 'package:polkadex/common/market_asset/domain/repositories/iasset_repository.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/network/error.dart';

class GetAssetsDetailsUseCase {
  GetAssetsDetailsUseCase({
    required IAssetRepository assetRepository,
  }) : _assetRepository = assetRepository;

  final IAssetRepository _assetRepository;

  Future<Either<ApiError, List<AssetEntity>>> call() async {
    return await _assetRepository.getAssetsDetails();
  }
}
