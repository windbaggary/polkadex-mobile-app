import 'package:equatable/equatable.dart';
import 'package:polkadex/common/graph/domain/entities/line_chart_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class CoinGraphState extends Equatable {
  const CoinGraphState({
    required this.timestampSelected,
  });

  final EnumAppChartTimestampTypes timestampSelected;

  @override
  List<Object> get props => [timestampSelected];
}

class CoinGraphInitial extends CoinGraphState {
  CoinGraphInitial({
    required EnumAppChartTimestampTypes timestampSelected,
  }) : super(
          timestampSelected: timestampSelected,
        );
}

class CoinGraphLoading extends CoinGraphState {
  CoinGraphLoading({
    required EnumAppChartTimestampTypes timestampSelected,
  }) : super(
          timestampSelected: timestampSelected,
        );
}

class CoinGraphError extends CoinGraphState {
  CoinGraphError({
    required EnumAppChartTimestampTypes timestampSelected,
    required this.errorMessage,
  }) : super(
          timestampSelected: timestampSelected,
        );

  final String errorMessage;
}

class CoinGraphLoaded extends CoinGraphState {
  CoinGraphLoaded({
    required EnumAppChartTimestampTypes timestampSelected,
    required this.dataList,
  }) : super(
          timestampSelected: timestampSelected,
        );

  final Map<String, List<LineChartEntity>> dataList;

  @override
  List<Object> get props => [
        timestampSelected,
        dataList,
      ];
}
