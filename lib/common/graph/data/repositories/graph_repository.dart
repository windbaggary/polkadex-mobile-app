import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:k_chart/entity/k_line_entity.dart';
import 'package:polkadex/common/graph/data/datasources/graph_remote_datasource.dart';
import 'package:polkadex/common/graph/domain/repositories/igraph_repository.dart';
import 'package:polkadex/common/utils/time_utils.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';

class GraphRepository implements IGraphRepository {
  GraphRepository({required GraphRemoteDatasource graphLocalDatasource})
      : _graphLocalDatasource = graphLocalDatasource;

  final GraphRemoteDatasource _graphLocalDatasource;

  @override
  Future<Either<ApiError, List<KLineEntity>>> getGraphData(
    String leftTokenId,
    String rightTokenId,
    EnumAppChartTimestampTypes timestampType,
  ) async {
    try {
      final result = await _graphLocalDatasource.getCoinGraphData(
        leftTokenId,
        rightTokenId,
        TimeUtils.timestampTypeToString(timestampType),
      );
      final Map<String, dynamic> body = jsonDecode(result.body);

      if (result.statusCode == 200 && body.containsKey('Fine')) {
        final listRawData = (body['Fine'] as List);

        final List<KLineEntity> dataKcharts = List<KLineEntity>.generate(
          listRawData.length,
          (index) => KLineEntity.fromCustom(
            open: listRawData[index]['open'],
            close: listRawData[index]['close'],
            time: DateTime.parse(listRawData[index]['time'])
                .millisecondsSinceEpoch,
            high: listRawData[index]['high'],
            low: listRawData[index]['low'],
            vol: listRawData[index]['volume'],
          ),
        ).toList();

        return Right(dataKcharts);
      } else {
        return Left(ApiError(message: body['Bad'] ?? result.reasonPhrase));
      }
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }
}
