import 'package:dartz/dartz.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/network/error.dart';

abstract class IGraphRepository {
  Future<Either<ApiError, List<LineChartEntity>>> getGraphData();
}
