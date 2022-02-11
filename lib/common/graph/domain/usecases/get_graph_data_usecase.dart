import 'package:dartz/dartz.dart';
import 'package:k_chart/entity/index.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/graph/domain/repositories/igraph_repository.dart';
import 'package:polkadex/common/utils/enums.dart';

class GetCoinGraphDataUseCase {
  GetCoinGraphDataUseCase({
    required IGraphRepository graphRepository,
  }) : _graphRepository = graphRepository;

  final IGraphRepository _graphRepository;

  Future<Either<ApiError, List<KLineEntity>>> call(String leftTokenId,
      String rightTokenId, EnumAppChartTimestampTypes timestampType) async {
    return await _graphRepository.getGraphData(
      leftTokenId,
      rightTokenId,
      timestampType,
    );
  }
}
