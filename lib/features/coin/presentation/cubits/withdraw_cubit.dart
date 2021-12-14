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
          address: '',
        ));

  final WithdrawUseCase _withdrawUseCase;

  void init({
    required double amountFree,
    required double amountToBeWithdrawn,
    required String address,
  }) {
    emit(WithdrawNotValid(
      amountFree: amountFree,
      amountToBeWithdrawn: amountToBeWithdrawn,
      address: address,
    ));
  }

  void updateWithdrawParams({
    double? amountFree,
    double? amountToBeWithdrawn,
    String? address,
  }) {
    final previousState = state;
    final newAmountFree = amountFree ?? previousState.amountFree;
    final newAmountToBeWithdrawn =
        amountToBeWithdrawn ?? previousState.amountToBeWithdrawn;
    final newAddress = address ?? previousState.address;

    print(newAddress);

    newAddress.length >= 48 && newAmountToBeWithdrawn > 0.0
        ? emit(WithdrawValid(
            amountFree: newAmountFree,
            amountToBeWithdrawn: newAmountToBeWithdrawn,
            address: newAddress,
          ))
        : emit(WithdrawNotValid(
            amountFree: newAmountFree,
            amountToBeWithdrawn: newAmountToBeWithdrawn,
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
    emit(WithdrawLoading(
      amountFree: amountFree,
      amountToBeWithdrawn: amountToBeWithdrawn,
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
          address: address,
          message: error.message,
        ),
      ),
      (success) => emit(
        WithdrawSuccess(
          amountFree: amountFree - amountToBeWithdrawn,
          amountToBeWithdrawn: 0.0,
          address: address,
          message: '$asset successfully withdrawn.',
        ),
      ),
    );
  }
}
