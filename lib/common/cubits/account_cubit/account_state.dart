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

class AccountVerifyingCode extends AccountState {
  AccountVerifyingCode({
    required this.email,
    required this.password,
  });

  final String email;
  final String? password;

  @override
  List<Object?> get props => [
        email,
        password,
      ];
}

class AccountUpdatingBiometric extends AccountLoaded {
  AccountUpdatingBiometric({
    required ImportedAccountEntity account,
    String? password,
  }) : super(account: account);
}

class AccountPasswordValidating extends AccountLoaded {
  AccountPasswordValidating({
    required ImportedAccountEntity account,
    String? password,
  }) : super(account: account);
}

class AccountUpdatingTimer extends AccountLoaded {
  AccountUpdatingTimer({
    required ImportedAccountEntity account,
    String? password,
  }) : super(account: account);
}
