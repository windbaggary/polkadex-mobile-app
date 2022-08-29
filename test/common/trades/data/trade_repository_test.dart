import 'package:amplify_api/amplify_api.dart';
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/user_data/user_data_remote_datasource.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/datasources/trade_remote_datasource.dart';
import 'package:polkadex/common/trades/data/repositories/trade_repository.dart';

class _MockTradeRemoteDatasource extends Mock implements TradeRemoteDatasource {
}

class _UserDataRemoteDatasource extends Mock
    implements UserDataRemoteDatasource {}

class _MockStream extends Mock implements Stream {}

void main() {
  late _MockTradeRemoteDatasource tradeDataSource;
  late _UserDataRemoteDatasource userDataSource;
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
  late String tMarket;
  late Stream tStream;
  late DateTime tFrom;
  late DateTime tTo;
  late String tPlaceOrderSuccess;

  setUp(() {
    tradeDataSource = _MockTradeRemoteDatasource();
    userDataSource = _UserDataRemoteDatasource();
    repository = TradeRepository(
      tradeRemoteDatasource: tradeDataSource,
      userDataRemoteDatasource: userDataSource,
    );
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    amount = "100.0";
    price = "50.0";
    mainAddress = 'test';
    proxyAddress = 'tset';
    tMarket = 'PDEX-1';
    tFrom = DateTime.fromMicrosecondsSinceEpoch(0);
    tTo = DateTime.now();
    tAccountTradeSuccess = '''{
      "listTransactionsByMainAccount": {
        "items": [
          {
            "tt": "DEPOSIT",
            "a": "PDEX",
            "q": "20000000000000",
            "fee": "0.000000",
            "st": "CONFIRMED",
            "t": "1661434434872"
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
            "u": "fjwhuerjghwsejdfkweldhjgea",
            "id": "239795334492173596420427136507382475609",
            "cid": "239795334492173596420427136507382475609",
            "t": "1661787799000",
            "m": "PDEX-1",
            "s": "Ask",
            "ot": "LIMIT",
            "st": "OPEN",
            "p": "00000001",
            "q": "00000001",
            "afp": "00000012",
            "fq": "08333333",
            "fee": "00000000"
          }
        ],
        "nextToken": null
      }
    }''';
    tPlaceOrderSuccess = '''{
      "place_order": "239795334492173596420427136507382475609"
    }''';
    tStream = _MockStream();
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('Trade repository tests ', () {
    test('Must return a success orders submit response', () async {
      when(() => tradeDataSource.placeOrder(
          any(), any(), any(), any(), any(), any(), any(), any())).thenAnswer(
        (_) async => GraphQLResponse(data: tPlaceOrderSuccess, errors: []),
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
      verify(() => tradeDataSource.placeOrder(mainAddress, proxyAddress,
          baseAsset, quoteAsset, 'Market', 'Bid', price, amount)).called(1);
      verifyNoMoreInteractions(tradeDataSource);
    });

    test('Must return a failed orders submit response', () async {
      when(() => tradeDataSource.placeOrder(
          any(), any(), any(), any(), any(), any(), any(), any())).thenAnswer(
        (_) async => throw RpcException(-32000, 'error'),
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
      verify(() => tradeDataSource.placeOrder(mainAddress, proxyAddress,
          baseAsset, quoteAsset, 'Market', 'Bid', price, amount)).called(1);
      verifyNoMoreInteractions(tradeDataSource);
    });
  });

  test('Must return a success orders fetch response', () async {
    when(() => tradeDataSource.fetchOrders(any(), any(), any())).thenAnswer(
      (_) async => GraphQLResponse(data: tOrdersSuccess, errors: []),
    );

    final result = await repository.fetchOrders(
      mainAddress,
      tFrom,
      tTo,
    );

    expect(result.isRight(), true);
    verify(() => tradeDataSource.fetchOrders(
          mainAddress,
          tFrom,
          tTo,
        )).called(1);
    verifyNoMoreInteractions(tradeDataSource);
  });

  test('Must return a failed orders fetch response', () async {
    when(() => tradeDataSource.fetchOrders(any(), any(), any())).thenAnswer(
      (_) async => throw Exception('Some arbitrary error'),
    );

    final result = await repository.fetchOrders(
      mainAddress,
      tFrom,
      tTo,
    );

    expect(result.isLeft(), true);
    verify(() => tradeDataSource.fetchOrders(
          mainAddress,
          tFrom,
          tTo,
        )).called(1);
    verifyNoMoreInteractions(tradeDataSource);
  });

  test('Must return a successful orders fetch live data response', () async {
    when(() => userDataSource.getUserDataStream(
          any(),
        )).thenAnswer(
      (_) async => tStream,
    );

    await repository.fetchOrdersUpdates(
      mainAddress,
      (_) {},
      (_) {},
    );

    verify(() => userDataSource.getUserDataStream(mainAddress)).called(1);
    verifyNoMoreInteractions(userDataSource);
  });

  test('Must return a success account trades fetch response', () async {
    when(() => tradeDataSource.fetchAccountTrades(any(), any(), any()))
        .thenAnswer(
      (_) async => GraphQLResponse(data: tAccountTradeSuccess, errors: []),
    );

    final result = await repository.fetchAccountTrades(
      mainAddress,
      tFrom,
      tTo,
    );

    expect(result.isRight(), true);
    verify(() => tradeDataSource.fetchAccountTrades(
          mainAddress,
          tFrom,
          tTo,
        )).called(1);
    verifyNoMoreInteractions(tradeDataSource);
  });

  test('Must return a failed account trades fetch response', () async {
    when(() => tradeDataSource.fetchAccountTrades(any(), any(), any()))
        .thenAnswer(
      (_) async => throw Exception('Some arbitrary error'),
    );

    final result = await repository.fetchAccountTrades(
      mainAddress,
      tFrom,
      tTo,
    );

    expect(result.isLeft(), true);
    verify(() => tradeDataSource.fetchAccountTrades(
          mainAddress,
          tFrom,
          tTo,
        )).called(1);
    verifyNoMoreInteractions(tradeDataSource);
  });

  test('Must return a successful fetch orderbook live data response', () async {
    when(() => userDataSource.getUserDataStream(
          any(),
        )).thenAnswer(
      (_) async => tStream,
    );

    await repository.fetchAccountTradesUpdates(
      mainAddress,
      (_) {},
      (_) {},
    );

    verify(() => userDataSource.getUserDataStream(mainAddress)).called(1);
    verifyNoMoreInteractions(userDataSource);
  });

  test('Must return a success recent trades fetch response', () async {
    when(() => tradeDataSource.fetchRecentTrades(any())).thenAnswer(
      (_) async => GraphQLResponse(data: tRecentTradeSuccess, errors: []),
    );

    final result = await repository.fetchRecentTrades(mainAddress);

    expect(result.isRight(), true);
    verify(() => tradeDataSource.fetchRecentTrades(mainAddress)).called(1);
    verifyNoMoreInteractions(tradeDataSource);
  });

  test('Must return a failed recent trades fetch response', () async {
    when(() => tradeDataSource.fetchRecentTrades(any())).thenAnswer(
      (_) async => throw Exception('Some arbitrary error'),
    );

    final result = await repository.fetchRecentTrades(mainAddress);

    expect(result.isLeft(), true);
    verify(() => tradeDataSource.fetchRecentTrades(mainAddress)).called(1);
    verifyNoMoreInteractions(tradeDataSource);
  });

  test('Must return a successful fetch recent trades live data response',
      () async {
    when(() => userDataSource.getUserDataStream(
          any(),
        )).thenAnswer(
      (_) async => tStream,
    );

    await repository.fetchRecentTradesUpdates(
      tMarket,
      (_) {},
      (_) {},
    );

    verify(() => userDataSource.getUserDataStream(tMarket)).called(1);
    verifyNoMoreInteractions(userDataSource);
  });
}
