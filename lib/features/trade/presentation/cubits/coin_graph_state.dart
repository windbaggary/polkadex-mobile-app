import 'package:equatable/equatable.dart';
import 'package:k_chart/entity/index.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class CoinGraphState extends Equatable {
  const CoinGraphState({
    required this.timestampSelected,
  });

  final EnumAppChartTimestampTypes timestampSelected;

  @override
  List<Object?> get props => [timestampSelected];
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
    required this.indexPointSelected,
  }) : super(
          timestampSelected: timestampSelected,
        );

  final List<KLineEntity> dataList;
  final int? indexPointSelected;

  CoinGraphLoaded copyWith({
    EnumAppChartTimestampTypes? timestampSelected,
    List<KLineEntity>? dataList,
    int? indexPointSelected,
  }) {
    return CoinGraphLoaded(
      timestampSelected: timestampSelected ?? this.timestampSelected,
      dataList: dataList ?? this.dataList,
      indexPointSelected: indexPointSelected ?? this.indexPointSelected,
    );
  }

  @override
  List<Object?> get props => [
        timestampSelected,
        dataList,
        indexPointSelected,
      ];
}
