import 'package:dartz/dartz.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:k_chart/entity/k_line_entity.dart';

abstract class IGraphRepository {
  Future<Either<ApiError, List<KLineEntity>>> getGraphData(String leftTokenId,
      String rightTokenId, EnumAppChartTimestampTypes timestampType);
}
