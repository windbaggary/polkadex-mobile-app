import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_account_trades_usecase.dart';

part 'trade_history_state.dart';

class TradeHistoryCubit extends Cubit<TradeHistoryState> {
  TradeHistoryCubit({
    required GetAccountTradesUseCase getTradesUseCase,
  })  : _getTradesUseCase = getTradesUseCase,
        super(TradeHistoryInitial());

  final GetAccountTradesUseCase _getTradesUseCase;

  List<AccountTradeEntity> _allTrades = [];

  Future<void> getAccountTrades(
    String asset,
    String address,
  ) async {
    emit(TradeHistoryLoading());

    final result = await _getTradesUseCase(
      address: address,
      from: DateTime.fromMicrosecondsSinceEpoch(0),
      to: DateTime.now(),
    );

    result.fold(
      (_) => emit(TradeHistoryError()),
      (trades) {
        _allTrades = trades.where((trade) {
          if (trade is OrderEntity) {
            return trade.asset == asset || trade.asset == asset;
          } else {
            return trade.asset == asset;
          }
        }).toList();
        _allTrades.sort((a, b) => b.time.compareTo(a.time));

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
    List<AccountTradeEntity> _tradesFiltered = [..._allTrades];

    if (dateFilter != null) {
      _tradesFiltered.removeWhere((trade) =>
          trade.time.isBefore(dateFilter.start) ||
          trade.time.isAfter(dateFilter.end));
    }

    if (filters.isNotEmpty) {
      _tradesFiltered.removeWhere((trade) => !filters.contains(trade.txnType));
    }

    emit(
      TradeHistoryLoaded(trades: _tradesFiltered),
    );
  }
}
