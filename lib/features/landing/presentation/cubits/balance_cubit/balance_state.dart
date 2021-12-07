part of 'balance_cubit.dart';

abstract class BalanceState extends Equatable {
  const BalanceState();

  @override
  List<Object> get props => [];
}

class BalanceInitial extends BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceError extends BalanceState {
  const BalanceError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [
        message,
      ];
}

class BalanceLoaded extends BalanceState {
  const BalanceLoaded({
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
