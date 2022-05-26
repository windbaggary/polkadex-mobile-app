import 'package:equatable/equatable.dart';

abstract class BalanceEntity extends Equatable {
  const BalanceEntity({
    required this.free,
    required this.reserved,
  });

  final Map free;
  final Map reserved;

  @override
  List<Object> get props => [
        free,
        reserved,
      ];
}
