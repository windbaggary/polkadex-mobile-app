import 'package:dartz/dartz.dart';
import 'package:polkadex/common/market_asset/domain/repositories/iasset_repository.dart';
import 'package:polkadex/common/network/error.dart';

class GetAssetsDetailsUseCase {
  GetAssetsDetailsUseCase({
    required IAssetRepository assetRepository,
  }) : _assetRepository = assetRepository;

  final IAssetRepository _assetRepository;

  Future<Either<ApiError, List<Map<String, dynamic>>?>> call() async {
    return await _assetRepository.getAssetsDetails();
  }
}
