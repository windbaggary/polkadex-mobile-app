import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/graph/domain/usecases/get_graph_data_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'coin_graph_state.dart';

class CoinGraphCubit extends Cubit<CoinGraphState> {
  CoinGraphCubit({
    required GetCoinGraphDataUseCase getGraphDataUseCase,
  })  : _getGraphDataUseCase = getGraphDataUseCase,
        super(CoinGraphInitial(
            timestampSelected: EnumAppChartTimestampTypes.oneHour));

  final GetCoinGraphDataUseCase _getGraphDataUseCase;

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

  Future<void> updatePointValues({required int? indexPointSelected}) async {
    final previousState = state;

    if (previousState is CoinGraphLoaded &&
        previousState.indexPointSelected != indexPointSelected) {
      emit(previousState.copyWith(indexPointSelected: indexPointSelected));
    }
  }
}
