import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/orderbook/data/datasources/orderbook_remote_datasource.dart';
import 'package:polkadex/common/orderbook/data/repositories/orderbook_repository.dart';

class _MockOrderbookRemoteDatasource extends Mock
    implements OrderbookRemoteDatasource {}

class _MockConsumer extends Mock implements Consumer {}

void main() {
  late _MockOrderbookRemoteDatasource dataSource;
  late _MockConsumer consumer;
  late OrderbookRepository repository;
  late String leftTokenId;
  late String rightTokenId;

  setUp(() {
    dataSource = _MockOrderbookRemoteDatasource();
    consumer = _MockConsumer();
    repository = OrderbookRepository(orderbookRemoteDatasource: dataSource);
    leftTokenId = '0';
    rightTokenId = '1';
  });

  group('Orderbook repository tests', () {
    test('Must return a successful fetch orderbook data response', () async {
      when(() => dataSource.getOrderbookData(any(), any())).thenAnswer(
        (_) async => Response(
            jsonEncode({
              "Fine": {"asks": [], "bids": []}
            }),
            200),
      );

      final result = await repository.getOrderbookData(
        leftTokenId,
        rightTokenId,
      );

      expect(result.isRight(), true);
      verify(() => dataSource.getOrderbookData(
            leftTokenId,
            rightTokenId,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed fetch orderbook data response', () async {
      when(() => dataSource.getOrderbookData(
            any(),
            any(),
          )).thenAnswer(
        (_) async => Response('', 400),
      );

      final result = await repository.getOrderbookData(
        leftTokenId,
        rightTokenId,
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.getOrderbookData(
            leftTokenId,
            rightTokenId,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a successful fetch orderbook live data response',
        () async {
      when(() => dataSource.getOrderbookConsumer(
            any(),
            any(),
          )).thenAnswer(
        (_) async => consumer,
      );

      final result = await repository.getOrderbookLiveData(
        leftTokenId,
        rightTokenId,
        (_) {},
        (_) {},
      );

      expect(result.isRight(), true);
      verify(() => dataSource.getOrderbookConsumer(
            leftTokenId,
            rightTokenId,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed fetch orderbook live data response', () async {
      when(() => dataSource.getOrderbookConsumer(
            any(),
            any(),
          )).thenAnswer(
        (_) async => null,
      );

      final result = await repository.getOrderbookLiveData(
        leftTokenId,
        rightTokenId,
        (_) {},
        (_) {},
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.getOrderbookConsumer(
            leftTokenId,
            rightTokenId,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
