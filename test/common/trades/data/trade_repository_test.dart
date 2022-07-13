import 'package:amplify_api/amplify_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/datasources/trade_remote_datasource.dart';
import 'package:polkadex/common/trades/data/repositories/trade_repository.dart';

class _MockTradeRemoteDatasource extends Mock implements TradeRemoteDatasource {
}

class _MockStream extends Mock implements Stream {}

void main() {
  late _MockTradeRemoteDatasource dataSource;
  late TradeRepository repository;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late String amount;
  late String price;
  late String mainAddress;
  late String proxyAddress;
  late String tOrdersSuccess;
  late String tAccountTradeSuccess;
  late String tRecentTradeSuccess;
  late Stream tStream;
  late DateTime tFrom;
  late DateTime tTo;

  setUp(() {
    dataSource = _MockTradeRemoteDatasource();
    repository = TradeRepository(tradeRemoteDatasource: dataSource);
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    amount = "100.0";
    price = "50.0";
    mainAddress = 'test';
    proxyAddress = 'tset';
    tFrom = DateTime.fromMicrosecondsSinceEpoch(0);
    tTo = DateTime.now();
    tAccountTradeSuccess = '''{
      "listTransactionsByMainAccount": {
        "items": [
          {
            "main_account": "asdfghj",
            "txn_type": "DEPOSIT",
            "asset": "PDEX",
            "amount": "20",
            "fee": "0.000000",
            "status": "CONFIRMED",
            "time": "2022-07-05T14:07:31.060470763+00:00"
          }
        ],
        "nextToken": null
      }
    }''';
    tRecentTradeSuccess = '''{
      "getRecentTrades": {
        "items": [
          {
            "m": "PDEX-1",
            "q": "1.0",
            "p": "1.0",
            "t": "2022-07-05T14:07:31.060470763+00:00"
          }
        ],
        "nextToken": null
      }
    }''';
    tOrdersSuccess = '''{
      "listOrderHistorybyMainAccount": {
        "items": [
          {
            "main_account": "fjwhuerjghwsejdfkweldhjgea",
            "id": "239795334492173596420427136507382475609",
            "time": "2022-07-05T18:44:43.989964791+00:00",
            "m": "PDEX-1",
            "side": "Ask",
            "order_type": "LIMIT",
            "status": "OPEN",
            "price": "12",
            "qty": "18",
            "avg_filled_price": "12",
            "filled_quantity": "0.08333333",
            "fee": "0.00000000"
          }
        ],
        "nextToken": null
      }
    }''';
    tStream = _MockStream();
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('Trade repository tests ', () {
    test('Must return a success orders submit response', () async {
      when(() => dataSource.placeOrder(
          any(), any(), any(), any(), any(), any(), any(), any())).thenAnswer(
        (_) async => '123456789',
      );

      final result = await repository.placeOrder(
        mainAddress,
        proxyAddress,
        baseAsset,
        quoteAsset,
        orderType,
        orderSide,
        price,
        amount,
      );

      expect(result.isRight(), true);
      verify(() => dataSource.placeOrder(mainAddress, proxyAddress, baseAsset,
          quoteAsset, 'Market', 'Bid', price, amount)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed orders submit response', () async {
      when(() => dataSource.placeOrder(
          any(), any(), any(), any(), any(), any(), any(), any())).thenAnswer(
        (_) async => null,
      );

      final result = await repository.placeOrder(
        mainAddress,
        proxyAddress,
        baseAsset,
        quoteAsset,
        orderType,
        orderSide,
        price,
        amount,
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.placeOrder(mainAddress, proxyAddress, baseAsset,
          quoteAsset, 'Market', 'Bid', price, amount)).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });

  test('Must return a success orders fetch response', () async {
    when(() => dataSource.fetchOrders(any(), any(), any())).thenAnswer(
      (_) async => GraphQLResponse(data: tOrdersSuccess, errors: []),
    );

    final result = await repository.fetchOrders(
      mainAddress,
      tFrom,
      tTo,
    );

    expect(result.isRight(), true);
    verify(() => dataSource.fetchOrders(
          mainAddress,
          tFrom,
          tTo,
        )).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a failed orders fetch response', () async {
    when(() => dataSource.fetchOrders(any(), any(), any())).thenAnswer(
      (_) async => throw Exception('Some arbitrary error'),
    );

    final result = await repository.fetchOrders(
      mainAddress,
      tFrom,
      tTo,
    );

    expect(result.isLeft(), true);
    verify(() => dataSource.fetchOrders(
          mainAddress,
          tFrom,
          tTo,
        )).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a success account trades fetch response', () async {
    when(() => dataSource.fetchAccountTrades(any(), any(), any())).thenAnswer(
      (_) async => GraphQLResponse(data: tAccountTradeSuccess, errors: []),
    );

    final result = await repository.fetchAccountTrades(
      mainAddress,
      tFrom,
      tTo,
    );

    expect(result.isRight(), true);
    verify(() => dataSource.fetchAccountTrades(
          mainAddress,
          tFrom,
          tTo,
        )).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a failed account trades fetch response', () async {
    when(() => dataSource.fetchAccountTrades(any(), any(), any())).thenAnswer(
      (_) async => throw Exception('Some arbitrary error'),
    );

    final result = await repository.fetchAccountTrades(
      mainAddress,
      tFrom,
      tTo,
    );

    expect(result.isLeft(), true);
    verify(() => dataSource.fetchAccountTrades(
          mainAddress,
          tFrom,
          tTo,
        )).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a successful fetch orderbook live data response', () async {
    when(() => dataSource.fetchAccountTradesUpdates(
          any(),
        )).thenAnswer(
      (_) async => tStream,
    );

    await repository.fetchAccountTradesUpdates(
      mainAddress,
      (_) {},
      (_) {},
    );

    verify(() => dataSource.fetchAccountTradesUpdates(mainAddress)).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a success recent trades fetch response', () async {
    when(() => dataSource.fetchRecentTrades(any())).thenAnswer(
      (_) async => GraphQLResponse(data: tRecentTradeSuccess, errors: []),
    );

    final result = await repository.fetchRecentTrades(mainAddress);

    expect(result.isRight(), true);
    verify(() => dataSource.fetchRecentTrades(mainAddress)).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a failed recent trades fetch response', () async {
    when(() => dataSource.fetchRecentTrades(any())).thenAnswer(
      (_) async => throw Exception('Some arbitrary error'),
    );

    final result = await repository.fetchRecentTrades(mainAddress);

    expect(result.isLeft(), true);
    verify(() => dataSource.fetchRecentTrades(mainAddress)).called(1);
    verifyNoMoreInteractions(dataSource);
  });
}
