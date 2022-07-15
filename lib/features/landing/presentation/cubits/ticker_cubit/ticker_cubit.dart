import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/get_all_tickers_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_ticker_updates_usecase.dart';

part 'ticker_state.dart';

class TickerCubit extends Cubit<TickerState> {
  TickerCubit({
    required GetAllTickersUseCase getAllTickersUseCase,
    required GetTickerUpdatesUseCase getTickerUpdatesUseCase,
  })  : _getAllTickersUseCase = getAllTickersUseCase,
        _getTickerUpdatesUseCase = getTickerUpdatesUseCase,
        super(TickerInitial());

  final GetAllTickersUseCase _getAllTickersUseCase;
  final GetTickerUpdatesUseCase _getTickerUpdatesUseCase;

  Future<void> getAllTickers() async {
    emit(TickerLoading());

    final result = await _getAllTickersUseCase();

    result.fold(
      (error) => emit(
        TickerError(message: error.message),
      ),
      (ticker) async {
        emit(TickerLoaded(ticker: ticker));

        for (var market in ticker.keys) {
          final assets = market.split('-');

          await _getTickerUpdatesUseCase(
            leftTokenId: assets[0],
            rightTokenId: assets[1],
            onMsgReceived: (newTicker) {
              final currentState = state;

              if (currentState is TickerLoaded) {
                final newMap = {...currentState.ticker}..[newTicker.m] =
                    newTicker;

                emit(TickerLoaded(ticker: newMap));
              }
            },
            onMsgError: (_) {},
          );
        }
      },
    );
  }
}
