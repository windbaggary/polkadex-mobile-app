import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/features/coin/domain/usecases/withdraw_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';

part 'withdraw_state.dart';

class WithdrawCubit extends Cubit<WithdrawState> {
  WithdrawCubit({
    required WithdrawUseCase withdrawUseCase,
    required GetBalanceUseCase getBalanceUseCase,
  })  : _withdrawUseCase = withdrawUseCase,
        _getBalanceUseCase = getBalanceUseCase,
        super(WithdrawInitial());

  final WithdrawUseCase _withdrawUseCase;
  final GetBalanceUseCase _getBalanceUseCase;

  Future<void> getBalance(
    String asset,
    String address,
    String signature,
  ) async {
    emit(WithdrawGettingBalance());

    final result = await _getBalanceUseCase(
      address: address,
      signature: signature,
    );

    result.fold(
      (error) => WithdrawBalanceError(message: error.message),
      (balance) => WithdrawLoaded(balance: balance.free[asset]),
    );
  }

  Future<void> withdraw(
    String asset,
    double amount,
    String address,
    String signature,
  ) async {
    emit(WithdrawLoading());

    final result = await _withdrawUseCase(
      asset: asset,
      amount: amount,
      address: address,
      signature: signature,
    );

    result.fold(
      (error) {},
      (success) {},
    );
  }
}
