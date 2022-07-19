import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/cancel_order_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_updates_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_usecase.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit({
    required GetOrdersUseCase getOrdersUseCase,
    required GetOrdersUpdatesUseCase getOrdersUpdatesUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _getOrdersUpdatesUseCase = getOrdersUpdatesUseCase,
        _cancelOrderUseCase = cancelOrderUseCase,
        super(OrderHistoryInitial());

  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrdersUpdatesUseCase _getOrdersUpdatesUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  List<OrderEntity> _allOrders = [];

  Future<void> getOrders(
    String asset,
    String address,
    bool isOpenOrdersPriority,
  ) async {
    emit(OrderHistoryLoading());

    final result = await _getOrdersUseCase(
      address: address,
      from: DateTime.fromMicrosecondsSinceEpoch(0),
      to: DateTime.now(),
    );

    await _getOrdersUpdatesUseCase(
      address: address,
      onMsgReceived: (newOrder) {
        final currentState = state;

        if (currentState is OrderHistoryLoaded) {
          final index = currentState.orders
              .indexWhere((order) => newOrder.tradeId == order.tradeId);

          if (index >= 0) {
            final newList = [...currentState.orders];
            newList[index] = newOrder;

            emit(
              OrderHistoryLoaded(
                  orders: newList,
                  orderIdsLoading: currentState.orderIdsLoading),
            );
          } else {
            emit(
              OrderHistoryLoaded(
                  orders: [newOrder, ...currentState.orders],
                  orderIdsLoading: currentState.orderIdsLoading),
            );
          }
        }
      },
      onMsgError: (error) => emit(
        OrderHistoryError(
          message: error.toString(),
        ),
      ),
    );

    result.fold(
      (error) => emit(OrderHistoryError(
        message: error.message,
      )),
      (orders) {
        _allOrders = orders
            .where((order) =>
                order.baseAsset == asset || order.quoteAsset == asset)
            .toList();
        _allOrders.sort((a, b) => b.time.compareTo(a.time));

        if (isOpenOrdersPriority) {
          _allOrders = orders
              .where((order) =>
                  order.baseAsset == asset || order.quoteAsset == asset)
              .toList();
          _allOrders.sort((a, b) {
            if (b.status == 'OPEN') {
              return 1;
            }
            return -1;
          });
        }

        emit(OrderHistoryLoaded(
          orders: _allOrders,
          orderIdsLoading: [],
        ));
      },
    );
  }

  Future<void> updateOrderHistoryFilter({
    required List<Enum> filters,
    DateTimeRange? dateFilter,
  }) async {
    final previousState = state;
    List<OrderEntity> _ordersFiltered = [..._allOrders];
    List<String> _ordersIdLoading;

    if (dateFilter != null) {
      _ordersFiltered.removeWhere((order) =>
          order.time.isBefore(dateFilter.start) ||
          order.time.isAfter(dateFilter.end));
    }

    if (filters.isNotEmpty) {
      _ordersFiltered
          .removeWhere((order) => !filters.contains(order.orderSide));
    }

    if (previousState is OrderHistoryLoaded) {
      _ordersIdLoading = previousState.orderIdsLoading;
    } else {
      _ordersIdLoading = [];
    }

    emit(
      OrderHistoryLoaded(
          orders: _ordersFiltered, orderIdsLoading: _ordersIdLoading),
    );
  }

  Future<bool> cancelOrder(
    OrderEntity order,
    String address,
  ) async {
    final firstPreviousState = state;

    if (firstPreviousState is OrderHistoryLoaded &&
        firstPreviousState.orders.contains(order)) {
      emit(OrderHistoryLoaded(
        orders: [...firstPreviousState.orders],
        orderIdsLoading: [
          ...firstPreviousState.orderIdsLoading,
          order.tradeId,
        ],
      ));

      final result = await _cancelOrderUseCase(
        address: address,
        baseAsset: order.baseAsset,
        quoteAsset: order.quoteAsset,
        orderId: order.tradeId,
      );

      final secondPreviousState = state;

      if (secondPreviousState is OrderHistoryLoaded) {
        final orderCancelled =
            (order as OrderModel).copyWith(status: 'CANCELLED');
        final index = secondPreviousState.orders.indexOf(order);

        emit(OrderHistoryLoaded(
          orders: result.isRight()
              ? ([...secondPreviousState.orders]..[index] = orderCancelled)
              : [...secondPreviousState.orders],
          orderIdsLoading: [...secondPreviousState.orderIdsLoading]
            ..remove(order.tradeId),
        ));
      }

      return result.isRight();
    } else {
      return false;
    }
  }
}
