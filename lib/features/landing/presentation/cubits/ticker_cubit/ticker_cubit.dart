import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/fetch_last_ticker_usecase.dart';

part 'ticker_state.dart';

class TickerCubit extends Cubit<TickerState> {
  TickerCubit({
    required FetchLastTickerUseCase fetchLastTickerUseCase,
  })  : _fetchLastTickerUseCase = fetchLastTickerUseCase,
        super(TickerInitial());

  final FetchLastTickerUseCase _fetchLastTickerUseCase;

  Future<void> getLastTicker({
    required String leftTokenId,
    required String rightTokenId,
  }) async {
    emit(TickerLoading());

    final result = await _fetchLastTickerUseCase(
      leftTokenId: leftTokenId,
      rightTokenId: rightTokenId,
    );

    result.fold(
      (error) => emit(
        TickerError(message: error.message),
      ),
      (ticker) => emit(TickerLoaded(ticker: ticker)),
    );
  }
}
