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
