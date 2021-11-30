import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/graph/data/datasources/graph_remote_datasource.dart';
import 'package:polkadex/common/graph/data/models/line_chart_model.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/graph/domain/repositories/igraph_repository.dart';
import 'package:polkadex/common/network/error.dart';

class GraphRepository implements IGraphRepository {
  GraphRepository({required GraphRemoteDatasource graphLocalDatasource})
      : _graphLocalDatasource = graphLocalDatasource;

  final GraphRemoteDatasource _graphLocalDatasource;

  @override
  Future<Either<ApiError, Map<String, List<LineChartEntity>>>>
      getGraphData() async {
    final result = await _graphLocalDatasource.getCoinGraphData();
    final Map<String, dynamic> body = jsonDecode(result.body);

    if (result.statusCode == 200 && body.containsKey('Fine')) {
      final dataLow = (body['Fine'] as List)
          .map((dynamic json) => LineChartModel.fromJsonLow(json))
          .toList();
      final dataHigh = (body['Fine'] as List)
          .map((dynamic json) => LineChartModel.fromJsonHigh(json))
          .toList();
      final dataAverage = (body['Fine'] as List)
          .map((dynamic json) => LineChartModel.fromJsonAverage(json))
          .toList();

      return Right({
        'low': dataLow,
        'high': dataHigh,
        'average': dataAverage,
      });
    } else {
      return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
    }
  }
}
