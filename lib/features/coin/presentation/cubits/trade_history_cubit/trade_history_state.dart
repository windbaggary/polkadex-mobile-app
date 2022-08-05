part of 'trade_history_cubit.dart';

abstract class TradeHistoryState extends Equatable {
  const TradeHistoryState({this.assetSelected});

  final AssetEntity? assetSelected;

  @override
  List<Object?> get props => [assetSelected];
}

class TradeHistoryInitial extends TradeHistoryState {
  TradeHistoryInitial({AssetEntity? assetSelected})
      : super(assetSelected: assetSelected);
}

class TradeHistoryLoading extends TradeHistoryState {
  TradeHistoryLoading({AssetEntity? assetSelected})
      : super(assetSelected: assetSelected);
}

class TradeHistoryError extends TradeHistoryState {
  TradeHistoryError({
    required this.message,
    AssetEntity? assetSelected,
  }) : super(assetSelected: assetSelected);

  final String message;

  @override
  List<Object?> get props => [
        message,
        assetSelected,
      ];
}

class TradeHistoryLoaded extends TradeHistoryState {
  const TradeHistoryLoaded({
    required this.trades,
    AssetEntity? assetSelected,
  }) : super(assetSelected: assetSelected);

  final List<AccountTradeEntity> trades;

  @override
  List<Object?> get props => [
        trades,
        assetSelected,
      ];
}
