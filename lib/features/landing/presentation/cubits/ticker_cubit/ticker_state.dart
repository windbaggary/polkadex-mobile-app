part of 'ticker_cubit.dart';

abstract class TickerState extends Equatable {
  const TickerState();

  @override
  List<Object> get props => [];
}

class TickerInitial extends TickerState {}

class TickerLoading extends TickerState {}

class TickerLoaded extends TickerState {
  const TickerLoaded({
    required this.ticker,
  });

  final TickerEntity ticker;

  @override
  List<Object> get props => [
        ticker,
      ];
}

class TickerError extends TickerState {
  const TickerError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [
        message,
      ];
}
