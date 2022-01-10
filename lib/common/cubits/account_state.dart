part of 'account_cubit.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountNotLoaded extends AccountState {}

class AccountLoaded extends AccountState {
  const AccountLoaded({required this.account});

  final ImportedAccountEntity account;

  @override
  List<Object> get props => [account];
}

class AccountUpdatingBiometric extends AccountLoaded {
  AccountUpdatingBiometric({required ImportedAccountEntity account})
      : super(account: account);
}

class AccountPasswordValidating extends AccountLoaded {
  AccountPasswordValidating({required ImportedAccountEntity account})
      : super(account: account);
}
