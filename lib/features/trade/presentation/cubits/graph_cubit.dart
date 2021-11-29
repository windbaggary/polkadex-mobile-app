import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/graph/domain/usecases/get_graph_data_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'graph_state.dart';

class GraphCubit extends Cubit<GraphState> {
  GraphCubit({
    required GetGraphDataUseCase getGraphDataUseCase,
  })  : _getGraphDataUseCase = getGraphDataUseCase,
        super(GraphInitial(typeSelected: EnumAppChartDataTypes.day));

  final GetGraphDataUseCase _getGraphDataUseCase;

  Future<void> loadGraph({EnumAppChartDataTypes? typeSelected}) async {
    final newTypeChart = typeSelected ?? state.typeSelected;
    emit(GraphLoading(typeSelected: newTypeChart));

    final result = await _getGraphDataUseCase();

    result.fold(
      (error) => GraphError(
        typeSelected: newTypeChart,
        errorMessage: error.message ??
            'Unexpected error on getting graph data. Please try again',
      ),
      (data) => GraphLoaded(typeSelected: newTypeChart, dataList: data),
    );
  }
}
