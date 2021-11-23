import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/domain/usecases/place_order_usecase.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({
    required PlaceOrderUseCase placeOrderUseCase,
  })  : _placeOrderUseCase = placeOrderUseCase,
        super(OrderInitial());

  final PlaceOrderUseCase _placeOrderUseCase;

  void updateOrderParams({
    required EnumBuySell orderside,
    double? balance,
    double? amount,
    double? price,
  }) {
    final currentState = state;
    final isOrderValid = amount != null &&
        price != null &&
        (orderside == EnumBuySell.buy ? price * amount : amount) <=
            (balance ?? state.balance);

    isOrderValid
        ? OrderValid(
            balance: balance ?? currentState.balance,
            amount: amount ?? currentState.amount,
            price: price ?? currentState.price,
          )
        : OrderNotValid(
            balance: balance ?? currentState.balance,
            amount: amount ?? currentState.amount,
            price: price ?? currentState.price,
          );
  }

  Future<void> placeOrder({
    required int nonce,
    required String baseAsset,
    required String quoteAsset,
    required EnumOrderTypes orderType,
    required EnumBuySell orderSide,
    required double price,
    required double quantity,
  }) async {
    emit(OrderLoading());

    final result = await _placeOrderUseCase(
      nonce: nonce,
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      orderType: orderType,
      orderSide: orderSide,
      price: price,
      quantity: quantity,
    );

    result.fold(
      (l) => emit(OrderNotAccepted()),
      (r) => emit(OrderAccepted()),
    );
  }
}
