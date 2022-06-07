import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_trades_usecase.dart';

part 'trade_history_state.dart';

class TradeHistoryCubit extends Cubit<TradeHistoryState> {
  TradeHistoryCubit({
    required GetTradesUseCase getTradesUseCase,
  })  : _getTradesUseCase = getTradesUseCase,
        super(TradeHistoryInitial());

  final GetTradesUseCase _getTradesUseCase;

  List<TradeEntity> _allTrades = [];

  Future<void> getTrades(
    String asset,
    String address,
  ) async {
    emit(TradeHistoryLoading());

    final result = await _getTradesUseCase(address: address);

    result.fold(
      (_) => emit(TradeHistoryError()),
      (trades) {
        _allTrades = trades
            .where((trade) =>
                trade.baseAsset == asset || trade.quoteAsset == asset)
            .toList();
        _allTrades.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        emit(TradeHistoryLoaded(
          trades: _allTrades,
        ));
      },
    );
  }

  Future<void> updateTradeHistoryFilter({
    required List<Enum> filters,
    DateTimeRange? dateFilter,
  }) async {
    List<TradeEntity> _tradesFiltered = [..._allTrades];

    if (dateFilter != null) {
      _tradesFiltered.removeWhere((trade) =>
          trade.timestamp.isBefore(dateFilter.start) ||
          trade.timestamp.isAfter(dateFilter.end));
    }

    if (filters.isNotEmpty) {
      _tradesFiltered.removeWhere((trade) => !filters.contains(trade.event));
    }

    emit(
      TradeHistoryLoaded(trades: _tradesFiltered),
    );
  }
}
