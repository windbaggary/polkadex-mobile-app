import 'package:amplify_api/amplify_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/orderbook/data/datasources/orderbook_remote_datasource.dart';
import 'package:polkadex/common/orderbook/data/repositories/orderbook_repository.dart';

class _MockOrderbookRemoteDatasource extends Mock
    implements OrderbookRemoteDatasource {}

class _MockConsumer extends Mock implements Stream {}

void main() {
  late _MockOrderbookRemoteDatasource dataSource;
  late _MockConsumer consumer;
  late OrderbookRepository repository;
  late String leftTokenId;
  late String rightTokenId;
  late String tDataSuccess;
  late String tDataError;

  setUp(() {
    dataSource = _MockOrderbookRemoteDatasource();
    consumer = _MockConsumer();
    repository = OrderbookRepository(orderbookRemoteDatasource: dataSource);
    leftTokenId = '0';
    rightTokenId = '1';
    tDataSuccess = '{"getOrderbook": {"items": [], "nextToken": null}}';
    tDataError =
        '{"getAllBalancesByMainAccount": {"items": [], "nextToken": null}}';
  });

  group('Orderbook repository tests', () {
    test('Must return a successful fetch orderbook data response', () async {
      when(() => dataSource.getOrderbookData(any(), any())).thenAnswer(
        (_) async => GraphQLResponse(data: tDataSuccess, errors: []),
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
        (_) async => GraphQLResponse(data: tDataError, errors: []),
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
      when(() => dataSource.getOrderbookStream(
            any(),
            any(),
          )).thenAnswer(
        (_) async => consumer,
      );

      await repository.getOrderbookUpdates(
        leftTokenId,
        rightTokenId,
        (_) {},
        (_) {},
      );

      verify(() => dataSource.getOrderbookStream(
            leftTokenId,
            rightTokenId,
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
