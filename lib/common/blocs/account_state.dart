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
