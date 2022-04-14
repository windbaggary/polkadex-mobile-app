import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/orders/domain/usecases/get_orders_usecase.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit({
    required GetOrdersUseCase getOrdersUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        super(OrderHistoryInitial());

  final GetOrdersUseCase _getOrdersUseCase;
  List<OrderEntity> _allOrders = [];

  Future<void> getOrders(
    String asset,
    String address,
    String signature,
      bool isOpenOrdersPriority,
  ) async {
    emit(OrderHistoryLoading());

    final result = await _getOrdersUseCase(
      address: address,
      signature: signature,
    );

    result.fold(
      (_) => emit(OrderHistoryError()),
      (orders) {
        _allOrders = orders
            .where((order) =>
                order.baseAsset == asset || order.quoteAsset == asset)
            .toList();
        _allOrders.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        if (isOpenOrdersPriority) {
          _allOrders = orders
              .where((order) =>
          order.baseAsset == asset || order.quoteAsset == asset)
              .toList();
          _allOrders.sort((a, b) {
            if(b.status == 'Open') {
              return 1;
            }
            return -1;
          });
        }

        emit(OrderHistoryLoaded(
          orders: _allOrders,
        ));
      },
    );
  }

  Future<void> updateOrderHistoryFilter({
    required List<Enum> filters,
    DateTimeRange? dateFilter,
  }) async {
    List<OrderEntity> _ordersFiltered = [..._allOrders];

    if (dateFilter != null) {
      _ordersFiltered.removeWhere((order) =>
          order.timestamp.isBefore(dateFilter.start) ||
          order.timestamp.isAfter(dateFilter.end));
    }

    if (filters.isNotEmpty) {
      _ordersFiltered
          .removeWhere((order) => !filters.contains(order.orderSide));
    }

    emit(OrderHistoryLoaded(orders: _ordersFiltered));
  }
}
