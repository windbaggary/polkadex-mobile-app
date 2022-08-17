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

class AccountVerifyingCode extends AccountState {
  AccountVerifyingCode({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

class AccountLogInError extends AccountLoaded {
  AccountLogInError({
    required ImportedAccountEntity account,
    required this.errorMessage,
  }) : super(
          account: account,
        );

  final String? errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
        account,
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

class AccountPasswordValidating extends AccountLoggedIn {
  AccountPasswordValidating({
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
