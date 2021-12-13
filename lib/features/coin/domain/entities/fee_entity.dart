import 'package:equatable/equatable.dart';

abstract class FeeEntity extends Equatable {
  const FeeEntity({
    required this.currency,
    required this.cost,
  });

  final String currency;
  final double cost;

  @override
  List<Object> get props => [
        currency,
        cost,
      ];
}
