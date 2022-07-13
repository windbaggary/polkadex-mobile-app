import 'package:equatable/equatable.dart';

abstract class RecentTradeEntity extends Equatable {
  const RecentTradeEntity({
    required this.m,
    required this.time,
    required this.price,
    required this.qty,
  });

  final String m;
  final DateTime time;
  final double price;
  final double qty;

  @override
  List<Object?> get props => [
        m,
        time,
        price,
        qty,
      ];
}
