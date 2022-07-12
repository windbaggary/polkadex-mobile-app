import 'dart:async';
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
  StreamSubscription? graphSubscription;

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

      final listData =
          jsonDecode(result.data)['getKlinesbyMarketInterval']['items'];

      final List<KLineEntity> dataKcharts = List<KLineEntity>.generate(
        listData.length,
        (index) => KLineEntity.fromCustom(
          open: double.parse(listData[index]['o']),
          close: double.parse(listData[index]['c']),
          time: DateTime.parse(listData[index]['t']).millisecondsSinceEpoch,
          high: double.parse(listData[index]['h']),
          low: double.parse(listData[index]['l']),
          vol: double.parse(listData[index]['v_base']),
        ),
      ).toList();

      return Right(dataKcharts);
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<void> getGraphUpdates(
    String leftTokenId,
    String rightTokenId,
    EnumAppChartTimestampTypes timestampType,
    Function(KLineEntity) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final Stream graphStream = await _graphLocalDatasource.getCoinGraphStream(
      leftTokenId,
      rightTokenId,
      TimeUtils.timestampTypeToString(timestampType),
    );

    await graphSubscription?.cancel();

    try {
      graphSubscription = graphStream.listen((message) {
        final data = message.data;

        if (message.data != null) {
          final liveData = jsonDecode(data)['onCandleStickEvents'];
          print(liveData);
          onMsgReceived(
            KLineEntity.fromCustom(
              open: double.parse(liveData['o']),
              close: double.parse(liveData['c']),
              time: DateTime.parse(liveData['t']).millisecondsSinceEpoch,
              high: double.parse(liveData['h']),
              low: double.parse(liveData['l']),
              vol: double.parse(liveData['v_base']),
            ),
          );
        }
      });
    } catch (error) {
      onMsgError(error);
    }
  }
}
