import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/account_trade_model.dart';
import 'package:polkadex/common/trades/data/models/recent_trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/datasources/trade_remote_datasource.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/common/utils/extensions.dart';

class TradeRepository implements ITradeRepository {
  TradeRepository({required TradeRemoteDatasource tradeRemoteDatasource})
      : _tradeRemoteDatasource = tradeRemoteDatasource;

  final TradeRemoteDatasource _tradeRemoteDatasource;
  StreamSubscription? accountTradeSubscription;
  StreamSubscription? orderSubscription;
  StreamSubscription? recentTradesSubscription;

  @override
  Future<Either<ApiError, OrderEntity>> placeOrder(
    String mainAddress,
    String proxyAddress,
    String baseAsset,
    String quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    String price,
    String amount,
  ) async {
    try {
      final result = await _tradeRemoteDatasource.placeOrder(
        mainAddress,
        proxyAddress,
        baseAsset == 'PDEX' ? '' : baseAsset,
        quoteAsset == 'PDEX' ? '' : quoteAsset,
        orderType.toString().split('.')[1].capitalize(),
        orderSide == EnumBuySell.buy ? 'Bid' : 'Ask',
        price,
        amount,
      );

      final newOrder = OrderModel(
        mainAccount: mainAddress,
        tradeId: result,
        clientId: '',
        qty: amount,
        price: price,
        orderSide: orderSide,
        orderType: orderType,
        time: DateTime.now(),
        baseAsset: baseAsset,
        quoteAsset: quoteAsset,
        status: orderType == EnumOrderTypes.market ? 'CLOSED' : 'OPEN',
      );

      return Right(newOrder);
    } on RpcException catch (rpcError) {
      return Left(ApiError(message: rpcError.message));
    } catch (e) {
      return Left(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiError, void>> cancelOrder(
    String address,
    String baseAsset,
    String quoteAsset,
    String orderId,
  ) async {
    try {
      await _tradeRemoteDatasource.cancelOrder(
        address,
        baseAsset == 'PDEX' ? '' : baseAsset,
        quoteAsset == 'PDEX' ? '' : quoteAsset,
        orderId,
      );

      return Right(null);
    } on RpcException catch (rpcError) {
      return Left(ApiError(message: rpcError.message));
    } catch (e) {
      return Left(ApiError(message: e.toString()));
    }
  }

  @override
  Future<Either<ApiError, List<OrderEntity>>> fetchOrders(
    String address,
    DateTime from,
    DateTime to,
  ) async {
    try {
      final result = await _tradeRemoteDatasource.fetchOrders(
        address,
        from,
        to,
      );

      final List<OrderEntity> listOrders = [];

      for (var transaction
          in jsonDecode(result.data)['listOrderHistorybyMainAccount']
              ['items']) {
        listOrders.add(OrderModel.fromJson(transaction));
      }

      return Right(listOrders);
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<void> fetchOrdersUpdates(
    String address,
    Function(OrderEntity) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final orderStream =
        await _tradeRemoteDatasource.fetchOrdersUpdates(address);

    await orderSubscription?.cancel();

    try {
      orderSubscription = orderStream.listen((message) {
        final data = message.data;

        if (message.data != null) {
          final liveData = jsonDecode(data)['onOrderUpdate'];
          onMsgReceived(
            OrderModel.fromJson(liveData),
          );
        }
      });
    } catch (error) {
      onMsgError(error);
    }
  }

  @override
  Future<Either<ApiError, List<RecentTradeEntity>>> fetchRecentTrades(
      String market) async {
    try {
      final result = await _tradeRemoteDatasource.fetchRecentTrades(market);

      final List<RecentTradeEntity> listRecentTrades = [];

      for (var transaction in jsonDecode(result.data)['getRecentTrades']
          ['items']) {
        listRecentTrades.add(RecentTradeModel.fromJson(transaction));
      }

      listRecentTrades.sort((a, b) => b.time.compareTo(a.time));

      return Right(listRecentTrades);
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<void> fetchRecentTradesUpdates(
    String market,
    Function(RecentTradeEntity) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final recentTradesStream =
        await _tradeRemoteDatasource.fetchRecentTradesStream(market);

    await recentTradesSubscription?.cancel();

    try {
      recentTradesSubscription = recentTradesStream.listen((message) {
        final data = message.data;

        if (message.data != null) {
          final liveData =
              jsonDecode(jsonDecode(data)['websocket_streams']['data']);

          onMsgReceived(
            RecentTradeModel.fromJson(liveData),
          );
        }
      });
    } catch (error) {
      onMsgError(error);
    }
  }

  @override
  Future<Either<ApiError, List<AccountTradeEntity>>> fetchAccountTrades(
    String address,
    DateTime from,
    DateTime to,
  ) async {
    try {
      final result = await _tradeRemoteDatasource.fetchAccountTrades(
        address,
        from,
        to,
      );

      final List<AccountTradeEntity> listTransactions = [];

      for (var transaction
          in jsonDecode(result.data)['listTransactionsByMainAccount']
              ['items']) {
        listTransactions.add(AccountTradeModel.fromJson(transaction));
      }

      return Right(listTransactions);
    } catch (_) {
      return Left(ApiError(message: 'Unexpected error. Please try again'));
    }
  }

  @override
  Future<void> fetchAccountTradesUpdates(
    String address,
    Function(AccountTradeEntity) onMsgReceived,
    Function(Object) onMsgError,
  ) async {
    final accountTradesStream =
        await _tradeRemoteDatasource.fetchAccountTradesUpdates(address);

    await accountTradeSubscription?.cancel();

    try {
      accountTradeSubscription = accountTradesStream.listen((message) {
        final data = message.data;

        if (message.data != null) {
          final liveData = jsonDecode(data)['onUpdateTransaction'];
          onMsgReceived(
            AccountTradeModel.fromJson(liveData),
          );
        }
      });
    } catch (error) {
      onMsgError(error);
    }
  }
}