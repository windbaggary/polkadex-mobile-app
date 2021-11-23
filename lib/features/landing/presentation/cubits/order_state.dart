part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState({
    this.balance = 0.0,
    this.amount = 0.0,
    this.price = 0.0,
  });

  final double balance;
  final double amount;
  final double price;

  @override
  List<Object> get props => [
        balance,
        amount,
        price,
      ];
}

class OrderInitial extends OrderState {}

class OrderValid extends OrderState {
  const OrderValid({
    required double balance,
    required double amount,
    required double price,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
        );
}

class OrderNotValid extends OrderState {
  const OrderNotValid({
    required double balance,
    required double amount,
    required double price,
  }) : super(
          balance: balance,
          amount: amount,
          price: price,
        );
}

class OrderLoading extends OrderState {}

class OrderAccepted extends OrderState {}

class OrderNotAccepted extends OrderState {}
