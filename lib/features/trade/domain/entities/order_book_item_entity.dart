import 'package:equatable/equatable.dart';

class OrderBookItemEntity extends Equatable {
  const OrderBookItemEntity({
    required this.amount,
    required this.price,
    required this.percentage,
  });

  final double amount;
  final double price;
  final double percentage;

  @override
  List<Object?> get props => [
        amount,
        price,
        percentage,
      ];
}
