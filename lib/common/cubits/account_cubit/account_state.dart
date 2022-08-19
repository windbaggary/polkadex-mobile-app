part of 'account_cubit.dart';

abstract class AccountState extends Equatable {
  AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountNotLoaded extends AccountState {
  AccountNotLoaded({
    this.errorMessage,
  });

  final String? errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AccountLoaded extends AccountState {
  AccountLoaded({
    required this.account,
  });

  final ImportedAccountEntity account;

  @override
  List<Object?> get props => [
        account,
      ];
}

class AccountLoading extends AccountState {}

class AccountLoggedIn extends AccountLoaded {
  AccountLoggedIn({
    required ImportedAccountEntity account,
    this.password,
  }) : super(
          account: account,
        );

  final String? password;

  @override
  List<Object?> get props => [
        account,
        password,
      ];
}

class AccountVerifyingCode extends AccountState {}

class AccountCodeResent extends AccountVerifyingCode {}

class AccountSignUpError extends AccountState {
  AccountSignUpError({
    this.errorMessage,
  });

  final String? errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AccountConfirmSignUpError extends AccountState {
  AccountConfirmSignUpError({
    this.errorMessage,
  });

  final String? errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AccountLogInError extends AccountState {
  AccountLogInError({
    this.errorMessage,
  });

  final String? errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AccountSignOutError extends AccountState {
  AccountSignOutError({
    this.errorMessage,
  });

  final String? errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AccountResendCodeError extends AccountState {
  AccountResendCodeError({
    this.errorMessage,
  });

  final String? errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AccountUpdatingBiometric extends AccountLoggedIn {
  AccountUpdatingBiometric({
    required ImportedAccountEntity account,
    String? password,
  }) : super(
          account: account,
          password: password,
        );
}

class AccountUpdatingTimer extends AccountLoggedIn {
  AccountUpdatingTimer({
    required ImportedAccountEntity account,
    String? password,
  }) : super(
          account: account,
          password: password,
        );
}
