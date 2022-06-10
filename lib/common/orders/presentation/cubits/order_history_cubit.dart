import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/orders/domain/usecases/get_orders_live_data_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/orders/domain/usecases/cancel_order_usecase.dart';
import 'package:polkadex/common/orders/domain/usecases/get_orders_usecase.dart';

part 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit({
    required GetOrdersUseCase getOrdersUseCase,
    required GetOrdersLiveDataUseCase getOrdersLiveDataUseCase,
    required CancelOrderUseCase cancelOrderUseCase,
  })  : _getOrdersUseCase = getOrdersUseCase,
        _getOrdersLiveDataUseCase = getOrdersLiveDataUseCase,
        _cancelOrderUseCase = cancelOrderUseCase,
        super(OrderHistoryInitial());

  final GetOrdersUseCase _getOrdersUseCase;
  final GetOrdersLiveDataUseCase _getOrdersLiveDataUseCase;
  final CancelOrderUseCase _cancelOrderUseCase;

  List<OrderEntity> _allOrders = [];

  Future<void> getOrders(
    String asset,
    String address,
    String signature,
    bool isOpenOrdersPriority,
  ) async {
    emit(OrderHistoryLoading());

    final result = await _getOrdersUseCase(address: address);

    final resultLiveData = await _getOrdersLiveDataUseCase(
      address: address,
      onMsgReceived: (orderUpdate) {
        print(orderUpdate.toString());
      },
      onMsgError: (error) => emit(
        OrderHistoryError(),
      ),
    );

    resultLiveData.fold(
        (error) => emit(
              OrderHistoryError(),
            ),
        (_) => null);

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
            if (b.status == EnumOrderStatus.partiallyFilled) {
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
          order.timestamp.isBefore(dateFilter.start) ||
          order.timestamp.isAfter(dateFilter.end));
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
    String signature,
  ) async {
    final firstPreviousState = state;

    if (firstPreviousState is OrderHistoryLoaded &&
        firstPreviousState.orders.contains(order)) {
      emit(OrderHistoryLoaded(
        orders: [...firstPreviousState.orders],
        orderIdsLoading: [
          ...firstPreviousState.orderIdsLoading,
          order.orderId,
        ],
      ));

      final result = await _cancelOrderUseCase(
        nonce: 0,
        address: address,
        orderId: order.orderId,
        signature: signature,
      );

      final secondPreviousState = state;

      if (secondPreviousState is OrderHistoryLoaded) {
        emit(OrderHistoryLoaded(
          orders: result.isRight()
              ? ([...secondPreviousState.orders]..remove(order))
              : [...secondPreviousState.orders],
          orderIdsLoading: [...secondPreviousState.orderIdsLoading]
            ..remove(order.orderId),
        ));
      }

      return result.isRight();
    } else {
      return false;
    }
  }

  Future<void> addToOpenOrders(OrderEntity newOrder) async {
    final previousState = state;

    if (previousState is OrderHistoryLoaded) {
      emit(
        OrderHistoryLoaded(
          orders: [newOrder, ...previousState.orders],
          orderIdsLoading: [...previousState.orderIdsLoading],
        ),
      );
    }
  }
}
