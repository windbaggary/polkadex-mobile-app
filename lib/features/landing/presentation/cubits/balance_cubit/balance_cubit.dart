import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_updates_usecase.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit({
    required GetBalanceUseCase getBalanceUseCase,
    required GetBalanceUpdatesUseCase getBalanceUpdatesUseCase,
  })  : _getBalanceUseCase = getBalanceUseCase,
        _getBalanceUpdatesUseCase = getBalanceUpdatesUseCase,
        super(BalanceInitial());

  final GetBalanceUseCase _getBalanceUseCase;
  final GetBalanceUpdatesUseCase _getBalanceUpdatesUseCase;
  Map _baseFree = {};
  Map _baseReserved = {};

  Future<void> getBalance(String address) async {
    emit(BalanceLoading());

    final result = await _getBalanceUseCase(address: address);

    await _getBalanceUpdatesUseCase(
      address: address,
      onMsgReceived: (balanceUpdate) {
        _baseFree.addAll(balanceUpdate.free);
        _baseReserved.addAll(balanceUpdate.reserved);

        emit(BalanceLoaded(
          free: Map.from(_baseFree),
          reserved: Map.from(_baseReserved),
        ));
      },
      onMsgError: (error) => emit(
        BalanceError(
          message: error.toString(),
        ),
      ),
    );

    final currentState = state;

    if (currentState is BalanceLoading) {
      result.fold(
        (error) => emit(
          BalanceError(message: error.message),
        ),
        (balance) {
          _baseFree = balance.free;
          _baseReserved = balance.reserved;

          emit(
            BalanceLoaded(
              free: balance.free,
              reserved: balance.reserved,
            ),
          );
        },
      );
    }
  }
}
