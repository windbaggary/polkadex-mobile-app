import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:polkadex/common/graph/data/datasources/graph_remote_datasource.dart';
import 'package:polkadex/common/graph/data/models/line_chart_model.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/graph/domain/repositories/igraph_repository.dart';
import 'package:polkadex/common/graph/utils/timestamp_utils.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';

class GraphRepository implements IGraphRepository {
  GraphRepository({required GraphRemoteDatasource graphLocalDatasource})
      : _graphLocalDatasource = graphLocalDatasource;

  final GraphRemoteDatasource _graphLocalDatasource;

  @override
  Future<Either<ApiError, Map<String, List<LineChartEntity>>>> getGraphData(
      EnumAppChartTimestampTypes timestampType) async {
    try {
      final result = await _graphLocalDatasource.getCoinGraphData(
          TimestampUtils.timestampTypeToString(timestampType));
      final Map<String, dynamic> body = jsonDecode(result.body);

      if (result.statusCode == 200 && body.containsKey('Fine')) {
        final listRawData = (body['Fine'] as List);

        final List<LineChartEntity> dataOpen = List<LineChartEntity>.generate(
          listRawData.length,
          (index) => LineChartModel.fromJsonOpen(listRawData[index]),
        ).toList();
        final List<LineChartEntity> dataLow = List<LineChartEntity>.generate(
          listRawData.length,
          (index) => LineChartModel.fromJsonLow(listRawData[index]),
        ).toList();
        final List<LineChartEntity> dataHigh = List<LineChartEntity>.generate(
          listRawData.length,
          (index) => LineChartModel.fromJsonHigh(listRawData[index]),
        ).toList();
        final List<LineChartEntity> dataClose = List<LineChartEntity>.generate(
          listRawData.length,
          (index) => LineChartModel.fromJsonClose(listRawData[index]),
        ).toList();
        final List<LineChartEntity> dataAverage =
            List<LineChartEntity>.generate(
          listRawData.length,
          (index) => LineChartModel.fromJsonAverage(listRawData[index]),
        ).toList();

        return Right({
          'open': dataOpen,
          'low': dataLow,
          'high': dataHigh,
          'close': dataClose,
          'average': dataAverage,
        });
      } else {
        return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }
}
