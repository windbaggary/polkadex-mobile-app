import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/get_all_tickers_usecase.dart';

part 'ticker_state.dart';

class TickerCubit extends Cubit<TickerState> {
  TickerCubit({
    required GetAllTickersUseCase getAllTickersUseCase,
  })  : _getAllTickersUseCase = getAllTickersUseCase,
        super(TickerInitial());

  final GetAllTickersUseCase _getAllTickersUseCase;

  Future<void> getAllTickers() async {
    emit(TickerLoading());

    final result = await _getAllTickersUseCase();

    result.fold(
      (error) => emit(
        TickerError(message: error.message),
      ),
      (ticker) => emit(TickerLoaded(ticker: ticker)),
    );
  }
}
