part of 'trade_history_cubit.dart';

abstract class TradeHistoryState extends Equatable {
  const TradeHistoryState();

  @override
  List<Object> get props => [];
}

class TradeHistoryInitial extends TradeHistoryState {}

class TradeHistoryLoading extends TradeHistoryState {}

class TradeHistoryError extends TradeHistoryState {
  TradeHistoryError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}

class TradeHistoryLoaded extends TradeHistoryState {
  const TradeHistoryLoaded({required this.trades});

  final List<AccountTradeEntity> trades;

  @override
  List<Object> get props => [trades];
}
