import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/features/coin/domain/usecases/withdraw_usecase.dart';
part 'withdraw_state.dart';

class WithdrawCubit extends Cubit<WithdrawState> {
  WithdrawCubit({
    required WithdrawUseCase withdrawUseCase,
  })  : _withdrawUseCase = withdrawUseCase,
        super(WithdrawInitial());

  final WithdrawUseCase _withdrawUseCase;

  Future<void> withdraw({
    required String asset,
    required double amountFree,
    required double amountToBeWithdrawn,
    required String address,
    required String signature,
  }) async {
    emit(WithdrawLoading(amount: amountFree));

    final result = await _withdrawUseCase(
      asset: asset,
      amount: amountToBeWithdrawn,
      address: address,
      signature: signature,
    );

    result.fold(
      (error) => emit(
        WithdrawError(message: error.message, amount: amountFree),
      ),
      (success) => emit(
        WithdrawSuccess(
            message: '$asset successfully withdrawn.',
            amount: amountFree - amountToBeWithdrawn),
      ),
    );
  }
}
