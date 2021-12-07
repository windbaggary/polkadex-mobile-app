import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit({
    required GetBalanceUseCase getBalanceUseCase,
  })  : _getBalanceUseCase = getBalanceUseCase,
        super(BalanceInitial());

  final GetBalanceUseCase _getBalanceUseCase;

  Future<void> getBalance(String address, String signature) async {
    emit(BalanceLoading());

    final result = await _getBalanceUseCase(
      address: address,
      signature: signature,
    );

    result.fold(
      (error) => emit(
        BalanceError(message: error.message!),
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
}
