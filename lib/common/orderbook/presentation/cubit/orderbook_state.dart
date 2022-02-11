part of 'orderbook_cubit.dart';

abstract class OrderbookState extends Equatable {
  OrderbookState();

  @override
  List<Object?> get props => [];
}

class OrderbookInitial extends OrderbookState {}

class OrderbookLoading extends OrderbookState {}

class OrderbookLoaded extends OrderbookState {
  OrderbookLoaded({
    required this.orderbook,
  });

  final OrderbookEntity orderbook;

  @override
  List<Object?> get props => [orderbook];
}

class OrderbookError extends OrderbookState {
  OrderbookError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}
