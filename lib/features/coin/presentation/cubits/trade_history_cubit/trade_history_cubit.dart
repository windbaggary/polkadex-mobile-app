import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_account_trades_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_account_trades_updates_usecase.dart';

part 'trade_history_state.dart';

class TradeHistoryCubit extends Cubit<TradeHistoryState> {
  TradeHistoryCubit({
    required GetAccountTradesUseCase getTradesUseCase,
    required GetAccountTradesUpdatesUseCase getAccountTradesUpdatesUseCase,
  })  : _getTradesUseCase = getTradesUseCase,
        _getAccountTradesUpdatesUseCase = getAccountTradesUpdatesUseCase,
        super(TradeHistoryInitial());

  final GetAccountTradesUseCase _getTradesUseCase;
  final GetAccountTradesUpdatesUseCase _getAccountTradesUpdatesUseCase;

  List<AccountTradeEntity> _allTrades = [];

  Future<void> getAccountTrades({
    required AssetEntity asset,
    required String address,
    List<Enum> filters = const [],
    DateTimeRange? dateFilter,
  }) async {
    emit(TradeHistoryLoading(assetSelected: asset));

    final result = await _getTradesUseCase(
      address: address,
      from: DateTime.fromMicrosecondsSinceEpoch(0),
      to: DateTime.now(),
    );

    await _getAccountTradesUpdatesUseCase(
      address: address,
      onMsgReceived: (newTrade) {
        final currentState = state;

        if (currentState is TradeHistoryLoaded) {
          final newList = [newTrade, ...currentState.trades];

          filters.isNotEmpty || dateFilter != null
              ? updateTradeHistoryFilter(
                  filters: filters,
                  dateFilter: dateFilter,
                )
              : emit(
                  TradeHistoryLoaded(
                    assetSelected: asset,
                    trades: newList,
                  ),
                );
        }
      },
      onMsgError: (error) => emit(
        TradeHistoryError(
          assetSelected: asset,
          message: error.toString(),
        ),
      ),
    );

    result.fold(
      (error) => emit(
        TradeHistoryError(
          assetSelected: asset,
          message: error.message,
        ),
      ),
      (trades) {
        _allTrades = trades.where((trade) {
          if (trade is OrderEntity) {
            return trade.asset == asset.assetId || trade.asset == asset.assetId;
          } else {
            return trade.asset == asset.assetId;
          }
        }).toList();
        _allTrades.sort((a, b) => b.time.compareTo(a.time));

        filters.isNotEmpty || dateFilter != null
            ? updateTradeHistoryFilter(
                filters: filters,
                dateFilter: dateFilter,
              )
            : emit(
                TradeHistoryLoaded(
                  assetSelected: asset,
                  trades: _allTrades,
                ),
              );
      },
    );
  }

  Future<void> updateTradeHistoryFilter({
    List<Enum> filters = const [],
    DateTimeRange? dateFilter,
  }) async {
    List<AccountTradeEntity> _tradesFiltered = [..._allTrades];
    final currentState = state;

    if (state is TradeHistoryLoaded) {
      if (dateFilter != null) {
        _tradesFiltered.removeWhere((trade) =>
            trade.time.isBefore(dateFilter.start) ||
            trade.time.isAfter(dateFilter.end));
      }

      if (filters.isNotEmpty) {
        _tradesFiltered
            .removeWhere((trade) => !filters.contains(trade.txnType));
      }

      emit(
        TradeHistoryLoaded(
          trades: _tradesFiltered,
          assetSelected: currentState.assetSelected,
        ),
      );
    }
  }
}
