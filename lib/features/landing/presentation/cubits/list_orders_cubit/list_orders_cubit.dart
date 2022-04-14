import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/orders/domain/usecases/get_open_orders.dart';

part 'list_orders_state.dart';

class ListOrdersCubit extends Cubit<ListOrdersState> {
  ListOrdersCubit({
    required GetOpenOrdersUseCase getOpenOrdersUseCase,
  })  : _getOpenOrdersUseCase = getOpenOrdersUseCase,
        super(ListOrdersInitial());

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
          openOrders: [newOrder, ...previousState.openOrders],
          orderIdsLoading: [...previousState.orderIdsLoading],
        ),
      );
    }
  }
}
