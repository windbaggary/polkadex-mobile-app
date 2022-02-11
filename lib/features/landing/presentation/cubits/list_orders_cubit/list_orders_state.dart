part of 'list_orders_cubit.dart';

abstract class ListOrdersState extends Equatable {
  const ListOrdersState();

  @override
  List<Object> get props => [];
}

class ListOrdersInitial extends ListOrdersState {}

class ListOrdersLoading extends ListOrdersState {}

class ListOrdersError extends ListOrdersState {}

class ListOrdersLoaded extends ListOrdersState {
  const ListOrdersLoaded({
    required this.openOrders,
    required this.orderUuidsLoading,
  });

  final List<OrderEntity> openOrders;
  final List<String> orderUuidsLoading;

  @override
  List<Object> get props => [
        openOrders,
        orderUuidsLoading,
      ];
}
