part of 'withdraw_cubit.dart';

abstract class WithdrawState extends Equatable {
  const WithdrawState();

  @override
  List<Object> get props => [];
}

class WithdrawInitial extends WithdrawState {}

abstract class WithdrawAmountUpdated extends WithdrawState {
  const WithdrawAmountUpdated({required this.amount});

  final double amount;

  @override
  List<Object> get props => [amount];
}

class WithdrawLoading extends WithdrawAmountUpdated {
  const WithdrawLoading({
    required double amount,
  }) : super(amount: amount);
}

class WithdrawError extends WithdrawAmountUpdated {
  const WithdrawError({
    required double amount,
    required this.message,
  }) : super(amount: amount);

  final String message;

  @override
  List<Object> get props => [
        amount,
        message,
      ];
}

class WithdrawSuccess extends WithdrawAmountUpdated {
  const WithdrawSuccess({
    required double amount,
    required this.message,
  }) : super(amount: amount);

  final String message;

  @override
  List<Object> get props => [
        amount,
        message,
      ];
}
