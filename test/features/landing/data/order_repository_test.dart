import 'dart:convert';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/datasources/order_remote_datasource.dart';
import 'package:polkadex/features/landing/data/repositories/order_repository.dart';

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
  late double quantity;
  late double price;
  late String signature;

  setUp(() {
    dataSource = _MockOrderRemoteDatasource();
    repository = OrderRepository(orderRemoteDatasource: dataSource);
    nonce = 0;
    baseAsset = "BTC";
    quoteAsset = "USD";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    quantity = 100.0;
    price = 50.0;
    signature = 'test';
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('Order repository tests ', () {
    test('Must return a success order submit response', () async {
      when(() => dataSource.placeOrder(
          any(), any(), any(), any(), any(), any(), any(), any())).thenAnswer(
        (_) async => Response(
            jsonEncode({
              "FineWithMessage": {
                "data": "123456789",
                "message": "Order placed successfully! :)"
              }
            }),
            200),
      );

      final result = await repository.placeOrder(
        nonce,
        baseAsset,
        quoteAsset,
        orderType,
        orderSide,
        price,
        quantity,
        signature,
      );

      expect(result.isRight(), true);
      verify(() => dataSource.placeOrder(nonce, baseAsset, quoteAsset,
          orderType, orderSide, price, quantity, signature)).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed order submit response', () async {
      when(() => dataSource.placeOrder(
          any(), any(), any(), any(), any(), any(), any(), any())).thenAnswer(
        (_) async => Response('', 400),
      );

      final result = await repository.placeOrder(
        nonce,
        baseAsset,
        quoteAsset,
        orderType,
        orderSide,
        price,
        quantity,
        signature,
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.placeOrder(nonce, baseAsset, quoteAsset,
          orderType, orderSide, price, quantity, signature)).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
