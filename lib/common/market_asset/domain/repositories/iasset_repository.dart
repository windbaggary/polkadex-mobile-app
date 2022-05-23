import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';

abstract class IAssetRepository {
  Future<Either<ApiError, List<Map<String, dynamic>>?>> getAssetsDetails();
}
