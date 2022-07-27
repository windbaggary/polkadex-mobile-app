import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/features/coin/domain/usecases/withdraw_usecase.dart';
part 'withdraw_state.dart';

class WithdrawCubit extends Cubit<WithdrawState> {
  WithdrawCubit({
    required WithdrawUseCase withdrawUseCase,
  })  : _withdrawUseCase = withdrawUseCase,
        super(WithdrawInitial(
          amountFree: 0.0,
          amountToBeWithdrawn: 0.0,
        ));

  final WithdrawUseCase _withdrawUseCase;

  void init({
    required double amountFree,
    required double amountToBeWithdrawn,
  }) {
    emit(WithdrawNotValid(
      amountFree: amountFree,
      amountToBeWithdrawn: amountToBeWithdrawn,
    ));
  }

  void updateWithdrawParams({
    double? amountFree,
    double? amountToBeWithdrawn,
  }) {
    final previousState = state;
    final newAmountFree = amountFree ?? previousState.amountFree;
    final newAmountToBeWithdrawn =
        amountToBeWithdrawn ?? previousState.amountToBeWithdrawn;

    newAmountToBeWithdrawn > 0.0 && newAmountToBeWithdrawn <= newAmountFree
        ? emit(WithdrawValid(
            amountFree: newAmountFree,
            amountToBeWithdrawn: newAmountToBeWithdrawn,
          ))
        : emit(WithdrawNotValid(
            amountFree: newAmountFree,
            amountToBeWithdrawn: newAmountToBeWithdrawn,
          ));
  }

  Future<void> withdraw({
    required String proxyAddress,
    required String mainAddress,
    required String asset,
    required double amountFree,
    required double amountToBeWithdrawn,
  }) async {
    emit(WithdrawLoading(
      amountFree: amountFree,
      amountToBeWithdrawn: amountToBeWithdrawn,
    ));

    final result = await _withdrawUseCase(
      proxyAddress: proxyAddress,
      mainAddress: mainAddress,
      asset: asset,
      amount: amountToBeWithdrawn,
    );

    result.fold(
      (error) => emit(
        WithdrawError(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
          message: error.message,
        ),
      ),
      (success) => emit(
        WithdrawSuccess(
          amountFree: amountFree - amountToBeWithdrawn,
          amountToBeWithdrawn: 0.0,
          message: '$asset successfully withdrawn.',
        ),
      ),
    );
  }
}
