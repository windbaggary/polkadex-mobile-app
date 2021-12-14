part of 'withdraw_cubit.dart';

abstract class WithdrawState extends Equatable {
  const WithdrawState(
      {required this.amountFree,
      required this.amountToBeWithdrawn,
      required this.address});

  final double amountFree;
  final double amountToBeWithdrawn;
  final String address;

  @override
  List<Object> get props => [
        amountFree,
        amountToBeWithdrawn,
        address,
      ];
}

class WithdrawInitial extends WithdrawState {
  const WithdrawInitial({
    required double amountFree,
    required double amountToBeWithdrawn,
    required String address,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
          address: address,
        );
}

class WithdrawLoading extends WithdrawState {
  const WithdrawLoading({
    required double amountFree,
    required double amountToBeWithdrawn,
    required String address,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
          address: address,
        );
}

class WithdrawValid extends WithdrawState {
  const WithdrawValid({
    required double amountFree,
    required double amountToBeWithdrawn,
    required String address,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
          address: address,
        );
}

class WithdrawNotValid extends WithdrawState {
  const WithdrawNotValid({
    required double amountFree,
    required double amountToBeWithdrawn,
    required String address,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
          address: address,
        );
}

class WithdrawError extends WithdrawState {
  const WithdrawError({
    required double amountFree,
    required double amountToBeWithdrawn,
    required String address,
    required this.message,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
          address: address,
        );

  final String message;

  @override
  List<Object> get props => [amountFree, amountToBeWithdrawn, address, message];
}

class WithdrawSuccess extends WithdrawState {
  const WithdrawSuccess({
    required double amountFree,
    required double amountToBeWithdrawn,
    required String address,
    required this.message,
  }) : super(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
          address: address,
        );

  final String message;

  @override
  List<Object> get props => [amountFree, amountToBeWithdrawn, address, message];
}
