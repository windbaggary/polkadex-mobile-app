import 'package:equatable/equatable.dart';

abstract class TickerEntity extends Equatable {
  const TickerEntity({
    required this.timestamp,
    required this.high,
    required this.low,
    required this.last,
    required this.previousClose,
    required this.average,
  });

  final DateTime timestamp;
  final String high;
  final String low;
  final String last;
  final String previousClose;
  final String average;

  @override
  List<Object?> get props =>
      [timestamp, high, low, last, previousClose, average];
}
