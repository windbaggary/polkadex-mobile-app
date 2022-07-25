import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_recent_trades_updates_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_recent_trades_usecase.dart';

part 'recent_trades_state.dart';

class RecentTradesCubit extends Cubit<RecentTradesState> {
  RecentTradesCubit({
    required GetRecentTradesUseCase getRecentTradesUseCase,
    required GetRecentTradesUpdatesUseCase getRecentTradesUpdatesUseCase,
  })  : _getRecentTradesUseCase = getRecentTradesUseCase,
        _getRecentTradesUpdatesUseCase = getRecentTradesUpdatesUseCase,
        super(RecentTradesInitial());

  final GetRecentTradesUseCase _getRecentTradesUseCase;
  final GetRecentTradesUpdatesUseCase _getRecentTradesUpdatesUseCase;

  Future<void> getRecentTrades(
    String market,
  ) async {
    emit(RecentTradesLoading());

    final result = await _getRecentTradesUseCase(market: market);

    await _getRecentTradesUpdatesUseCase(
      market: market,
      onMsgReceived: (newRecentTrade) {
        final currentState = state;

        if (currentState is RecentTradesLoaded) {
          final newIsUpTendency =
              newRecentTrade.price >= currentState.trades.first.price
                  ? true
                  : false;

          emit(
            RecentTradesLoaded(
              trades: [...currentState.trades]..insert(0, newRecentTrade),
              isUpTendency: newIsUpTendency,
            ),
          );
        }
      },
      onMsgError: (error) => emit(
        RecentTradesError(
          message: error.toString(),
        ),
      ),
    );

    result.fold(
      (error) => emit(RecentTradesError(message: error.message)),
      (recentTrades) => emit(RecentTradesLoaded(trades: recentTrades)),
    );
  }
}
