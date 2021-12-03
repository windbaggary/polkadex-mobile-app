import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/graph/domain/repositories/igraph_repository.dart';
import 'package:polkadex/common/utils/enums.dart';

class GetCoinGraphDataUseCase {
  GetCoinGraphDataUseCase({
    required IGraphRepository graphRepository,
  }) : _graphRepository = graphRepository;

  final IGraphRepository _graphRepository;

  Future<Either<ApiError, Map<String, List<LineChartEntity>>>> call(
      EnumAppChartTimestampTypes timestampType) async {
    return await _graphRepository.getGraphData(timestampType);
  }
}
