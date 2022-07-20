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
    this.isUpTendency = true,
  });

  final List<RecentTradeEntity> trades;
  final bool isUpTendency;
  @override
  List<Object> get props => [
        trades,
        isUpTendency,
      ];
}
