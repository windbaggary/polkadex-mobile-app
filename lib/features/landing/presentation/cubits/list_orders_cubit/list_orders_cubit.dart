import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/models/order_model.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/cancel_order_usecase.dart';

part 'list_orders_state.dart';

class ListOrdersCubit extends Cubit<ListOrdersState> {
  ListOrdersCubit({
    required CancelOrderUseCase cancelOrderUseCase,
  })  : _cancelOrderUseCase = cancelOrderUseCase,
        super(ListOrdersInitial());

  final CancelOrderUseCase _cancelOrderUseCase;

  Future<void> getOpenOrders() async {
    final List<OrderEntity> _openOrders = <OrderEntity>[
      OrderModel(
        uuid: 'b47d2527-5a0c-11ea-822c-1831bf9834b0',
        type: EnumBuySell.buy,
        amount: '0.2900',
        price: '0.4423',
        dateTime: DateTime.now(),
        amountCoin: "DOT",
        priceCoin: "BTC",
        orderType: EnumOrderTypes.limit,
        tokenPairName: "DOT/BTC",
      )
    ];
    final List<String> _orderUuidsLoading = [];

    emit(ListOrdersLoaded(
      openOrders: _openOrders,
      orderUuidsLoading: _orderUuidsLoading,
    ));
  }

  Future<void> addToOpenOrders(OrderEntity newOrder) async {
    final previousState = state;

    if (previousState is ListOrdersLoaded) {
      emit(
        ListOrdersLoaded(
          openOrders: [...previousState.openOrders, newOrder],
          orderUuidsLoading: [...previousState.orderUuidsLoading],
        ),
      );
    }
  }

  Future<bool> cancelOrder(OrderEntity order) async {
    final firstPreviousState = state;

    if (firstPreviousState is ListOrdersLoaded &&
        firstPreviousState.openOrders.contains(order)) {
      emit(ListOrdersLoaded(
        openOrders: [...firstPreviousState.openOrders],
        orderUuidsLoading: [
          ...firstPreviousState.orderUuidsLoading,
          order.uuid
        ],
      ));

      final result = await _cancelOrderUseCase(
        nonce: 0,
        baseAsset: order.amountCoin,
        quoteAsset: order.priceCoin,
        orderUuid: order.uuid,
      );

      final secondPreviousState = state;

      if (secondPreviousState is ListOrdersLoaded) {
        emit(ListOrdersLoaded(
          openOrders: result.isRight()
              ? ([...secondPreviousState.openOrders]..remove(order))
              : [...secondPreviousState.openOrders],
          orderUuidsLoading: [...secondPreviousState.orderUuidsLoading]
            ..remove(order.uuid),
        ));
      }

      return result.isRight();
    } else {
      return false;
    }
  }
}
