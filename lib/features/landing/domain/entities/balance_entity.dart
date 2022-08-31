import 'package:equatable/equatable.dart';

abstract class BalanceEntity extends Equatable {
  const BalanceEntity({
    required this.free,
    required this.reserved,
  });

  final Map<String, double> free;
  final Map<String, double> reserved;

  @override
  List<Object> get props => [
        free,
        reserved,
      ];
}
