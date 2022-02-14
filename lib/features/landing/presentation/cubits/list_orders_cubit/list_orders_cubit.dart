import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/cancel_order_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_open_orders.dart';

part 'list_orders_state.dart';

class ListOrdersCubit extends Cubit<ListOrdersState> {
  ListOrdersCubit({
    required CancelOrderUseCase cancelOrderUseCase,
    required GetOpenOrdersUseCase getOpenOrdersUseCase,
  })  : _cancelOrderUseCase = cancelOrderUseCase,
        _getOpenOrdersUseCase = getOpenOrdersUseCase,
        super(ListOrdersInitial());

  final CancelOrderUseCase _cancelOrderUseCase;
  final GetOpenOrdersUseCase _getOpenOrdersUseCase;

  Future<void> getOpenOrders(String address, String signature) async {
    final List<OrderEntity> _openOrders = [];
    final List<String> _orderIdsLoading = [];

    emit(ListOrdersLoading());

    final result = await _getOpenOrdersUseCase(
      address: address,
      signature: signature,
    );

    result.fold(
      (_) => emit(ListOrdersError()),
      (orders) {
        _openOrders.addAll(orders);
        emit(ListOrdersLoaded(
          openOrders: _openOrders,
          orderIdsLoading: _orderIdsLoading,
        ));
      },
    );
  }

  Future<void> addToOpenOrders(OrderEntity newOrder) async {
    final previousState = state;

    if (previousState is ListOrdersLoaded) {
      emit(
        ListOrdersLoaded(
          openOrders: [...previousState.openOrders, newOrder],
          orderIdsLoading: [...previousState.orderIdsLoading],
        ),
      );
    }
  }

  Future<bool> cancelOrder(
    OrderEntity order,
    String address,
    String signature,
  ) async {
    final firstPreviousState = state;

    if (firstPreviousState is ListOrdersLoaded &&
        firstPreviousState.openOrders.contains(order)) {
      emit(ListOrdersLoaded(
        openOrders: [...firstPreviousState.openOrders],
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

      if (secondPreviousState is ListOrdersLoaded) {
        emit(ListOrdersLoaded(
          openOrders: result.isRight()
              ? ([...secondPreviousState.openOrders]..remove(order))
              : [...secondPreviousState.openOrders],
          orderIdsLoading: [...secondPreviousState.orderIdsLoading]
            ..remove(order.orderId),
        ));
      }

      return result.isRight();
    } else {
      return false;
    }
  }
}
