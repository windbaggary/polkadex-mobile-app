part of 'withdraw_cubit.dart';

abstract class WithdrawState extends Equatable {
  const WithdrawState();

  @override
  List<Object> get props => [];
}

class WithdrawInitial extends WithdrawState {}

class WithdrawLoading extends WithdrawState {}

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
