import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/place_order_usecase.dart';

part 'place_order_state.dart';

class PlaceOrderCubit extends Cubit<PlaceOrderState> {
  PlaceOrderCubit({
    required PlaceOrderUseCase placeOrderUseCase,
  })  : _placeOrderUseCase = placeOrderUseCase,
        super(PlaceOrderInitial());

  final PlaceOrderUseCase _placeOrderUseCase;

  void updateOrderParams({
    EnumBuySell? orderside,
    double? balance,
    double? amount,
    double? price,
  }) {
    final previousState = state;
    final newBalance = balance ?? previousState.balance;
    final newAmount = amount ?? previousState.amount;
    final newPrice = price ?? previousState.price;
    final newOrderside = orderside ?? previousState.orderSide;

    final isOrderValid = newAmount > 0.0 &&
        newPrice > 0.0 &&
        (newOrderside == EnumBuySell.buy ? newPrice * newAmount : newAmount) <=
            newBalance;

    isOrderValid
        ? emit(PlaceOrderValid(
            balance: newBalance,
            amount: newAmount,
            price: newPrice,
            orderSide: newOrderside,
          ))
        : emit(PlaceOrderNotValid(
            balance: newBalance,
            amount: newAmount,
            price: newPrice,
            orderSide: newOrderside,
          ));
  }

  Future<OrderEntity?> placeOrder({
    required String mainAddress,
    required String proxyAddress,
    required String baseAsset,
    required String quoteAsset,
    required EnumOrderTypes orderType,
    required EnumBuySell orderSide,
    required String price,
    required String amount,
  }) async {
    final previousState = state;
    OrderEntity? newOrder;

    emit(PlaceOrderLoading(
      balance: previousState.balance,
      orderSide: previousState.orderSide,
    ));

    final result = await _placeOrderUseCase(
      mainAddress: mainAddress,
      proxyAddress: proxyAddress,
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      orderType: orderType,
      orderSide: orderSide,
      price: price,
      amount: amount,
    );

    result.fold(
      (_) => emit(PlaceOrderNotAccepted(
        balance: previousState.balance,
        amount: 0.0,
        price: 0.0,
        orderSide: orderSide,
      )),
      (order) {
        emit(PlaceOrderAccepted(
          balance: previousState.balance,
          amount: 0.0,
          price: 0.0,
          orderSide: orderSide,
        ));
        newOrder = order;
      },
    );

    return newOrder;
  }
}
