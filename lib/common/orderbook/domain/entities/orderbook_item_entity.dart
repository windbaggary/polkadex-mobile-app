import 'package:equatable/equatable.dart';

abstract class OrderbookItemEntity extends Equatable {
  const OrderbookItemEntity({
    required this.price,
    required this.amount,
  });

  final double price;
  final double amount;

  @override
  List<Object?> get props => [
        price,
        amount,
      ];
}
