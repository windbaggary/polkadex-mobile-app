part of 'order_history_cubit.dart';

abstract class OrderHistoryState extends Equatable {
  const OrderHistoryState();

  @override
  List<Object> get props => [];
}

class OrderHistoryInitial extends OrderHistoryState {}

class OrderHistoryLoading extends OrderHistoryState {}

class OrderHistoryError extends OrderHistoryState {}

class OrderHistoryLoaded extends OrderHistoryState {
  const OrderHistoryLoaded({
    required this.orders,
    required this.orderIdsLoading,
  });

  final List<OrderEntity> orders;
  final List<String> orderIdsLoading;

  @override
  List<Object> get props => [
        orders,
        orderIdsLoading,
      ];
}
