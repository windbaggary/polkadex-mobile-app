import 'package:equatable/equatable.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class CoinGraphState extends Equatable {
  const CoinGraphState({required this.typeSelected});

  final EnumAppChartDataTypes typeSelected;

  @override
  List<Object> get props => [typeSelected];
}

class CoinGraphInitial extends CoinGraphState {
  CoinGraphInitial({required EnumAppChartDataTypes typeSelected})
      : super(typeSelected: typeSelected);
}

class CoinGraphLoading extends CoinGraphState {
  CoinGraphLoading({required EnumAppChartDataTypes typeSelected})
      : super(typeSelected: typeSelected);
}

class CoinGraphError extends CoinGraphState {
  CoinGraphError({
    required EnumAppChartDataTypes typeSelected,
    required this.errorMessage,
  }) : super(typeSelected: typeSelected);

  final String errorMessage;
}

class CoinGraphLoaded extends CoinGraphState {
  CoinGraphLoaded({
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
