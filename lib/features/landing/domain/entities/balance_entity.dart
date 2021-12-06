import 'package:equatable/equatable.dart';

abstract class BalanceEntity extends Equatable {
  const BalanceEntity({
    required this.free,
    required this.used,
    required this.total,
  });

  final Map free;
  final Map used;
  final Map total;

  @override
  List<Object> get props => [
        free,
        used,
        total,
      ];
}
