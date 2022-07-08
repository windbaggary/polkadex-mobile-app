import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_recent_trades_usecase.dart';

part 'recent_trades_state.dart';

class RecentTradesCubit extends Cubit<RecentTradesState> {
  RecentTradesCubit({
    required GetRecentTradesUseCase getRecentTradesUseCase,
  })  : _getRecentTradesUseCase = getRecentTradesUseCase,
        super(RecentTradesInitial());

  final GetRecentTradesUseCase _getRecentTradesUseCase;

  Future<void> getRecentTrades(
    String market,
  ) async {
    emit(RecentTradesLoading());

    final result = await _getRecentTradesUseCase(market: market);

    result.fold(
      (_) => emit(RecentTradesError()),
      (recentTrades) => emit(RecentTradesLoaded(trades: recentTrades)),
    );
  }
}
