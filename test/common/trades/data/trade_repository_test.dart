import 'dart:typed_data';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:mysql_client/mysql_protocol.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/datasources/trade_remote_datasource.dart';
import 'package:polkadex/common/trades/data/repositories/trade_repository.dart';

class _MockTradeRemoteDatasource extends Mock implements TradeRemoteDatasource {
}

void main() {
  late _MockTradeRemoteDatasource dataSource;
  late TradeRepository repository;
  late int nonce;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late String amount;
  late String price;
  late String address;

  setUp(() {
    dataSource = _MockTradeRemoteDatasource();
    repository = TradeRepository(tradeRemoteDatasource: dataSource);
    nonce = 0;
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    amount = "100.0";
    price = "50.0";
    address = 'test';
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
        nonce,
        baseAsset,
        quoteAsset,
        orderType,
        orderSide,
        price,
        amount,
        address,
      );

      expect(result.isRight(), true);
      verify(() => dataSource.placeOrder(nonce, baseAsset, quoteAsset, 'Market',
          'Bid', price, amount, address)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed orders submit response', () async {
      when(() => dataSource.placeOrder(
          any(), any(), any(), any(), any(), any(), any(), any())).thenAnswer(
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
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.placeOrder(nonce, baseAsset, quoteAsset, 'Market',
          'Bid', price, amount, address)).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });

  test('Must return a success orders fetch response', () async {
    when(() => dataSource.fetchOrders(any())).thenAnswer(
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

    final result = await repository.fetchOrders(address);

    expect(result.isRight(), true);
    verify(() => dataSource.fetchOrders(address)).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a success trades fetch response', () async {
    when(() => dataSource.fetchOrders(any())).thenAnswer(
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
    when(() => dataSource.fetchTrades(any())).thenAnswer(
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

    final result = await repository.fetchTrades(address);

    expect(result.isRight(), true);
    verify(() => dataSource.fetchOrders(address)).called(1);
    verify(() => dataSource.fetchTrades(address)).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a failed orders fetch response', () async {
    when(() => dataSource.fetchOrders(any())).thenAnswer(
      (_) async => throw Exception('Some arbitrary error'),
    );

    final result = await repository.fetchOrders(address);

    expect(result.isLeft(), true);
    verify(() => dataSource.fetchOrders(address)).called(1);
    verifyNoMoreInteractions(dataSource);
  });

  test('Must return a failed trades fetch response', () async {
    when(() => dataSource.fetchTrades(any())).thenAnswer(
      (_) async => throw Exception('Some arbitrary error'),
    );

    final result = await repository.fetchTrades(address);

    expect(result.isLeft(), true);
    verify(() => dataSource.fetchTrades(address)).called(1);
    verifyNoMoreInteractions(dataSource);
  });
}
