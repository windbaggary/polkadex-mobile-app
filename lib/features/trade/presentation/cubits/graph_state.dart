import 'package:equatable/equatable.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class GraphState extends Equatable {
  const GraphState({required this.typeSelected});

  final EnumAppChartDataTypes typeSelected;

  @override
  List<Object> get props => [typeSelected];
}

class GraphInitial extends GraphState {
  GraphInitial({required EnumAppChartDataTypes typeSelected})
      : super(typeSelected: typeSelected);
}

class GraphLoading extends GraphState {
  GraphLoading({required EnumAppChartDataTypes typeSelected})
      : super(typeSelected: typeSelected);
}

class GraphError extends GraphState {
  GraphError({
    required EnumAppChartDataTypes typeSelected,
    required this.errorMessage,
  }) : super(typeSelected: typeSelected);

  final String errorMessage;
}

class GraphLoaded extends GraphState {
  GraphLoaded({
    required EnumAppChartDataTypes typeSelected,
    required this.dataList,
  }) : super(typeSelected: typeSelected);

  final List<LineChartEntity> dataList;

  @override
  List<Object> get props => [
        typeSelected,
        dataList,
      ];
}
