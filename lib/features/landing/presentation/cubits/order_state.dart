part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState({
    this.balance = 0.0,
    this.amount = 0.0,
    this.price = 0.0,
    this.orderSide = EnumBuySell.buy,
  });

  final double balance;
  final double amount;
  final double price;
  final EnumBuySell orderSide;

  @override
  List<Object> get props => [
        balance,
        amount,
        price,
        orderSide,
      ];
}

class OrderInitial extends OrderState {}

class OrderValid extends OrderState {
  const OrderValid({
    required double balance,
    required double amount,
    required double price,
    required EnumBuySell orderSide,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
          orderSide: orderSide,
        );
}

class OrderNotValid extends OrderState {
  const OrderNotValid({
    required double balance,
    required double amount,
    required double price,
    required EnumBuySell orderSide,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
          orderSide: orderSide,
        );
}

class OrderLoading extends OrderState {}

class OrderAccepted extends OrderNotValid {
  const OrderAccepted({
    required double balance,
    required double amount,
    required double price,
    required EnumBuySell orderSide,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
          orderSide: orderSide,
        );
}

class OrderNotAccepted extends OrderNotValid {
  const OrderNotAccepted({
    required double balance,
    required double amount,
    required double price,
    required EnumBuySell orderSide,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
          orderSide: orderSide,
        );
}
