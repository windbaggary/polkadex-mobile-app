import 'package:dartz/dartz.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class IGraphRepository {
  Future<Either<ApiError, Map<String, List<LineChartEntity>>>> getGraphData(
      EnumAppChartTimestampTypes timestampType);
}
