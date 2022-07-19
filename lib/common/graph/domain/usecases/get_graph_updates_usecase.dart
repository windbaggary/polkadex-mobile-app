import 'package:k_chart/entity/k_line_entity.dart';
import 'package:polkadex/common/graph/domain/repositories/igraph_repository.dart';
import 'package:polkadex/common/utils/enums.dart';

class GetGraphUpdatesUseCase {
  GetGraphUpdatesUseCase({
    required IGraphRepository graphRepository,
  }) : _graphRepository = graphRepository;

  final IGraphRepository _graphRepository;

  Future<void> call({
    required String leftTokenId,
    required String rightTokenId,
    required EnumAppChartTimestampTypes timestampType,
    required Function(KLineEntity) onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _graphRepository.getGraphUpdates(
        leftTokenId, rightTokenId, timestampType, onMsgReceived, onMsgError);
  }
}
