part of 'account_cubit.dart';

abstract class AccountState extends Equatable {
  AccountState();

  @override
  List<Object?> get props => [];
}

class AccountInitial extends AccountState {}

class AccountNotLoaded extends AccountState {}

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

class AccountVerifyingCode extends AccountNotLoaded {}

class AccountCodeResent extends AccountVerifyingCode {}

class AccountSignUpError extends AccountNotLoaded {
  AccountSignUpError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AccountConfirmSignUpError extends AccountVerifyingCode {
  AccountConfirmSignUpError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AccountNotLoadedLogInError extends AccountNotLoaded {
  AccountNotLoadedLogInError({
    required this.errorMessage,
  });

  final String errorMessage;

  @override
  List<Object?> get props => [
        errorMessage,
      ];
}

class AccountLoadedLogInError extends AccountLoaded {
  AccountLoadedLogInError({
    required ImportedAccountEntity account,
    this.errorMessage,
  }) : super(
          account: account,
        );

  final String? errorMessage;

  @override
  List<Object?> get props => [
        account,
        errorMessage,
      ];
}

class AccountLoadedSignOutError extends AccountLoaded {
  AccountLoadedSignOutError({
    required ImportedAccountEntity account,
    required this.errorMessage,
  }) : super(account: account);

  final String? errorMessage;

  @override
  List<Object?> get props => [
        account,
        errorMessage,
      ];
}

class AccountLoggedInSignOutError extends AccountLoggedIn {
  AccountLoggedInSignOutError({
    required ImportedAccountEntity account,
    String? password,
    required this.errorMessage,
  }) : super(
          account: account,
          password: password,
        );

  final String? errorMessage;

  @override
  List<Object?> get props => [
        account,
        password,
        errorMessage,
      ];
}

class AccountResendCodeError extends AccountVerifyingCode {
  AccountResendCodeError({
    required this.errorMessage,
  });

  final String errorMessage;

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
