import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/graph/domain/usecases/get_graph_data_usecase.dart';
import 'package:polkadex/common/graph/domain/usecases/get_graph_updates_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'coin_graph_state.dart';

class CoinGraphCubit extends Cubit<CoinGraphState> {
  CoinGraphCubit({
    required GetCoinGraphDataUseCase getGraphDataUseCase,
    required GetGraphUpdatesUseCase getGraphUpdatesUseCase,
  })  : _getGraphDataUseCase = getGraphDataUseCase,
        _getGraphUpdatesUseCase = getGraphUpdatesUseCase,
        super(CoinGraphInitial(
            timestampSelected: EnumAppChartTimestampTypes.oneHour));

  final GetCoinGraphDataUseCase _getGraphDataUseCase;
  final GetGraphUpdatesUseCase _getGraphUpdatesUseCase;

  Future<void> loadGraph(String leftTokenId, String rightTokenId,
      {EnumAppChartTimestampTypes? timestampSelected}) async {
    final newTimestampChart = timestampSelected ?? state.timestampSelected;
    emit(CoinGraphLoading(timestampSelected: newTimestampChart));

    final result = await _getGraphDataUseCase(
      leftTokenId,
      rightTokenId,
      newTimestampChart,
      DateTime.fromMicrosecondsSinceEpoch(0),
      DateTime.now(),
    );

    await _getGraphUpdatesUseCase(
      leftTokenId: leftTokenId,
      rightTokenId: rightTokenId,
      timestampType: newTimestampChart,
      onMsgReceived: (newKline) {
        final currentState = state;

        if (currentState is CoinGraphLoaded) {
          final newGraphList = [...currentState.dataList, newKline];

          emit(
            CoinGraphLoaded(
              timestampSelected: newTimestampChart,
              dataList: newGraphList,
              indexPointSelected: null,
            ),
          );
        }
      },
      onMsgError: (error) => CoinGraphError(
        timestampSelected: newTimestampChart,
        errorMessage: error.toString(),
      ),
    );

    result.fold(
      (error) => emit(CoinGraphError(
        timestampSelected: newTimestampChart,
        errorMessage: error.message,
      )),
      (data) => emit(CoinGraphLoaded(
        timestampSelected: newTimestampChart,
        dataList: data,
        indexPointSelected: null,
      )),
    );
  }
}
