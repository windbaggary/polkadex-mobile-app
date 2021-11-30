import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/graph/domain/usecases/get_graph_data_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'coin_graph_state.dart';

class CoinGraphCubit extends Cubit<CoinGraphState> {
  CoinGraphCubit({
    required GetCoinGraphDataUseCase getGraphDataUseCase,
  })  : _getGraphDataUseCase = getGraphDataUseCase,
        super(CoinGraphInitial(
            timestampSelected: EnumAppChartTimestampTypes.day));

  final GetCoinGraphDataUseCase _getGraphDataUseCase;

  Future<void> loadGraph({EnumAppChartTimestampTypes? typeSelected}) async {
    final newTypeChart = typeSelected ?? state.timestampSelected;
    emit(CoinGraphLoading(timestampSelected: newTypeChart));

    final result = await _getGraphDataUseCase();

    result.fold(
      (error) => emit(CoinGraphError(
        timestampSelected: newTypeChart,
        errorMessage: error.message ??
            'Unexpected error on getting graph data. Please try again',
      )),
      (data) => emit(
          CoinGraphLoaded(timestampSelected: newTypeChart, dataList: data)),
    );
  }
}
