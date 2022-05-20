import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:mysql_client/mysql_protocol.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/data/datasources/order_remote_datasource.dart';
import 'package:polkadex/common/orders/data/repositories/order_repository.dart';

class _MockOrderRemoteDatasource extends Mock implements OrderRemoteDatasource {
}

void main() {
  late _MockOrderRemoteDatasource dataSource;
  late OrderRepository repository;
  late int nonce;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late String amount;
  late String price;
  late String address;
  late String signature;
  late List orderList;

  setUp(() {
    dataSource = _MockOrderRemoteDatasource();
    repository = OrderRepository(orderRemoteDatasource: dataSource);
    nonce = 0;
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    amount = "100.0";
    price = "50.0";
    address = 'test';
    signature = 'test';
    orderList = [
      {
        "order_id": "786653432",
        "main_acc": "5HDnQBPKDNUXL9qvWVzP8j3pgoh6Sa",
        "price": "7",
        "amount": "25.0",
        "order_side": "Buy",
        "order_type": "Market",
        "timestamp": 1644853305519,
        "base_asset": 0,
        "quote_asset": 1,
        "status": "Open",
        "filled_qty": "2.5",
        "fee": {"currency": 0, "cost": "0"},
        "trades": []
      },
      {
        "order_id": "786653433",
        "main_acc": "5HDnQBPKDNUXL9qvWVzP8j3pgoh6Sa",
        "price": "7",
        "amount": "25.0",
        "order_side": "Buy",
        "order_type": "Limit",
        "timestamp": 1644853305519,
        "base_asset": 0,
        "quote_asset": 1,
        "status": "Open",
        "filled_qty": "2.5",
        "fee": {"currency": 0, "cost": "0"},
        "trades": []
      }
    ];
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('Order repository tests ', () {
    test('Must return a success orders submit response', () async {
      when(() => dataSource.placeOrder(
              any(), any(), any(), any(), any(), any(), any(), any(), any()))
          .thenAnswer(
        (_) async => '123456789',
      );

      final result = await repository.placeOrder(
        nonce,
        baseAsset,
        quoteAsset,
        orderType,
        orderSide,
        price,
        amount,
        address,
        signature,
      );

      expect(result.isRight(), true);
      verify(() => dataSource.placeOrder(
          nonce,
          int.parse(baseAsset),
          int.parse(quoteAsset),
          'Market',
          'Bid',
          price,
          amount,
          address,
          signature)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed orders submit response', () async {
      when(() => dataSource.placeOrder(
              any(), any(), any(), any(), any(), any(), any(), any(), any()))
          .thenAnswer(
        (_) async => null,
      );

      final result = await repository.placeOrder(
        nonce,
        baseAsset,
        quoteAsset,
        orderType,
        orderSide,
        price,
        amount,
        address,
        signature,
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.placeOrder(
          nonce,
          int.parse(baseAsset),
          int.parse(quoteAsset),
          'Market',
          'Bid',
          price,
          amount,
          address,
          signature)).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });

  test('Must return a success open orders fetch response', () async {
    when(() => dataSource.fetchOpenOrders(
          any(),
          any(),
        )).thenAnswer(
      (_) async => Response(jsonEncode({"Fine": orderList}), 200),
    );

    final result = await repository.fetchOpenOrders(
      address,
      signature,
    );

    expect(result.isRight(), true);
    verify(() => dataSource.fetchOpenOrders(address, signature)).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a failed open orders fetch response', () async {
    when(() => dataSource.fetchOpenOrders(
          any(),
          any(),
        )).thenAnswer(
      (_) async => Response(jsonEncode({"Bad": "error"}), 400),
    );

    final result = await repository.fetchOpenOrders(
      address,
      signature,
    );

    expect(result.isLeft(), true);
    verify(() => dataSource.fetchOpenOrders(address, signature)).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a success orders fetch response', () async {
    when(() => dataSource.fetchOrders(
          any(),
          any(),
        )).thenAnswer(
      (_) async => EmptyResultSet(
        okPacket: MySQLPacketOK.decode(
          Uint8List.fromList(
            [
              0x62,
              0x6c,
              0xc3,
              0xa5,
              0x62,
              0xc3,
              0xa6,
              0x72,
              0x67,
              0x72,
              0xc3,
              0xb8,
              0x64
            ],
          ),
        ),
      ),
    );

    final result = await repository.fetchOrders(
      address,
      signature,
    );

    expect(result.isRight(), true);
    verify(() => dataSource.fetchOrders(address, signature)).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a failed orders fetch response', () async {
    when(() => dataSource.fetchOrders(
          any(),
          any(),
        )).thenAnswer(
      (_) async => throw Exception('Some arbitrary error'),
    );

    final result = await repository.fetchOrders(
      address,
      signature,
    );

    expect(result.isLeft(), true);
    verify(() => dataSource.fetchOrders(address, signature)).called(1);
    verifyNoMoreInteractions(dataSource);
  });
}
