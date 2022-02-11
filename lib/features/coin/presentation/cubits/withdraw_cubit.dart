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
          amountDisplayed: '0',
          address: '',
        ));

  final WithdrawUseCase _withdrawUseCase;

  void init({
    required double amountFree,
    required double amountToBeWithdrawn,
    required String amountDisplayed,
    required String address,
  }) {
    emit(WithdrawNotValid(
      amountFree: amountFree,
      amountToBeWithdrawn: amountToBeWithdrawn,
      amountDisplayed: amountDisplayed,
      address: address,
    ));
  }

  void updateWithdrawParams({
    double? amountFree,
    double? amountToBeWithdrawn,
    String? amountDisplayed,
    String? address,
  }) {
    final previousState = state;
    final newAmountFree = amountFree ?? previousState.amountFree;
    final newAmountToBeWithdrawn =
        amountToBeWithdrawn ?? previousState.amountToBeWithdrawn;
    final newAmountDisplayed = amountDisplayed ?? previousState.amountDisplayed;
    final newAddress = address ?? previousState.address;

    newAddress.length >= 48 &&
            newAmountToBeWithdrawn > 0.0 &&
            newAmountToBeWithdrawn <= newAmountFree
        ? emit(WithdrawValid(
            amountFree: newAmountFree,
            amountToBeWithdrawn: newAmountToBeWithdrawn,
            amountDisplayed: newAmountDisplayed,
            address: newAddress,
          ))
        : emit(WithdrawNotValid(
            amountFree: newAmountFree,
            amountToBeWithdrawn: newAmountToBeWithdrawn,
            amountDisplayed: newAmountDisplayed,
            address: newAddress,
          ));
  }

  Future<void> withdraw({
    required String asset,
    required double amountFree,
    required double amountToBeWithdrawn,
    required String address,
    required String signature,
  }) async {
    final previousState = state;

    emit(WithdrawLoading(
      amountFree: amountFree,
      amountToBeWithdrawn: amountToBeWithdrawn,
      amountDisplayed: previousState.amountDisplayed,
      address: address,
    ));

    final result = await _withdrawUseCase(
      asset: asset,
      amount: amountToBeWithdrawn,
      address: address,
      signature: signature,
    );

    result.fold(
      (error) => emit(
        WithdrawError(
          amountFree: amountFree,
          amountToBeWithdrawn: amountToBeWithdrawn,
          amountDisplayed: previousState.amountDisplayed,
          address: address,
          message: error.message,
        ),
      ),
      (success) => emit(
        WithdrawSuccess(
          amountFree: amountFree - amountToBeWithdrawn,
          amountToBeWithdrawn: 0.0,
          amountDisplayed: '0',
          address: address,
          message: '$asset successfully withdrawn.',
        ),
      ),
    );
  }
}
