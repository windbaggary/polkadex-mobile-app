part of 'recent_trades_cubit.dart';

abstract class RecentTradesState extends Equatable {
  const RecentTradesState();

  @override
  List<Object> get props => [];
}

class RecentTradesInitial extends RecentTradesState {}

class RecentTradesLoading extends RecentTradesState {}

class RecentTradesError extends RecentTradesState {}

class RecentTradesLoaded extends RecentTradesState {
  const RecentTradesLoaded({
    required this.trades,
  });

  final List<RecentTradeEntity> trades;

  @override
  List<Object> get props => [trades];
}
