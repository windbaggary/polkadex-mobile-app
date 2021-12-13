part of 'withdraw_cubit.dart';

abstract class WithdrawState extends Equatable {
  const WithdrawState();

  @override
  List<Object> get props => [];
}

class WithdrawInitial extends WithdrawState {}

class WithdrawGettingBalance extends WithdrawState {}

class WithdrawLoading extends WithdrawState {}

class WithdrawLoaded extends WithdrawState {
  const WithdrawLoaded({
    required this.balance,
  });

  final double balance;

  @override
  List<Object> get props => [
        balance,
      ];
}

class WithdrawBalanceError extends WithdrawState {
  const WithdrawBalanceError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [
        message,
      ];
}

class WithdrawError extends WithdrawState {
  const WithdrawError({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [
        message,
      ];
}

class WithdrawSuccess extends WithdrawState {
  const WithdrawSuccess({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [
        message,
      ];
}
