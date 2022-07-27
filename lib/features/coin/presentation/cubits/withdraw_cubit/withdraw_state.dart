part of 'withdraw_cubit.dart';

abstract class WithdrawState extends Equatable {
  const WithdrawState({
    required this.amountFree,
    required this.amountToBeWithdrawn,
  });

  final double amountFree;
  final double amountToBeWithdrawn;

  @override
  List<Object> get props => [
        amountFree,
        amountToBeWithdrawn,
      ];
}

class WithdrawInitial extends WithdrawState {
  const WithdrawInitial({
    required double amountFree,
    required double amountToBeWithdrawn,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
        );
}

class WithdrawLoading extends WithdrawState {
  const WithdrawLoading({
    required double amountFree,
    required double amountToBeWithdrawn,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
        );
}

class WithdrawValid extends WithdrawState {
  const WithdrawValid({
    required double amountFree,
    required double amountToBeWithdrawn,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
        );
}

class WithdrawNotValid extends WithdrawState {
  const WithdrawNotValid({
    required double amountFree,
    required double amountToBeWithdrawn,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
        );
}

class WithdrawError extends WithdrawState {
  const WithdrawError({
    required double amountFree,
    required double amountToBeWithdrawn,
    required this.message,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
        );

  final String message;

  @override
  List<Object> get props => [
        amountFree,
        amountToBeWithdrawn,
        message,
      ];
}

class WithdrawSuccess extends WithdrawState {
  const WithdrawSuccess({
    required double amountFree,
    required double amountToBeWithdrawn,
    required this.message,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
        );

  final String message;

  @override
  List<Object> get props => [
        amountFree,
        amountToBeWithdrawn,
        message,
      ];
}
