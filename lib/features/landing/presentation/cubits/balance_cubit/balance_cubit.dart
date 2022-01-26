import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/test_deposit_usecase.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit({
    required GetBalanceUseCase getBalanceUseCase,
    required TestDepositUseCase testDepositUseCase,
  })  : _getBalanceUseCase = getBalanceUseCase,
        _testDepositUseCase = testDepositUseCase,
        super(BalanceInitial());

  final GetBalanceUseCase _getBalanceUseCase;
  final TestDepositUseCase _testDepositUseCase;

  Future<void> getBalance(String address, String signature) async {
    emit(BalanceLoading());

    final result = await _getBalanceUseCase(
      address: address,
      signature: signature,
    );

    result.fold(
      (error) => emit(
        BalanceError(message: error.message),
      ),
      (balance) => emit(
        BalanceLoaded(
          free: balance.free,
          used: balance.used,
          total: balance.total,
        ),
      ),
    );
  }

  Future<void> testDeposit(String address, String signature) async {
    final previousState = state;

    emit(BalanceLoading());

    final result = await _testDepositUseCase(
      address: address,
      signature: signature,
    );

    result.fold(
      (error) => emit(previousState),
      (balance) => getBalance(address, signature),
    );
  }
}
