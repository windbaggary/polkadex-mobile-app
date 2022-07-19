import 'package:amplify_api/amplify_api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/data/datasources/ticker_remote_datasource.dart';
import 'package:polkadex/features/landing/data/repositories/ticker_repository.dart';

class _MockTickerRemoteDatasource extends Mock
    implements TickerRemoteDatasource {}

class _MockStream extends Mock implements Stream {}

void main() {
  late _MockTickerRemoteDatasource dataSource;
  late TickerRepository repository;
  late _MockStream stream;
  late String tDataSuccess;
  late String tDataError;

  setUp(() {
    dataSource = _MockTickerRemoteDatasource();
    repository = TickerRepository(tickerRemoteDatasource: dataSource);
    stream = _MockStream();
    tDataSuccess = '''{
      "getAllMarketTickers": {
        "items": [{
            "m":"PDEX-1",
            "priceChange24Hr":"-4.9979",
            "priceChangePercent24Hr":"-0.3331933333333333",
            "open":"15",
            "close":"10.0021",
            "high":"100",
            "low":"0.01",
            "volumeBase24hr":"584.8233333300001",
            "volumeQuote24Hr":"638.550543228393"
            }],
        "nextToken": null
      }
    }''';
    tDataError = '''{
      "getAllBalancesByMainAccount": {
        "items": [
          {"asset": "PDEX", "free": "100.0", "reversed": "0.0"}
        ],
        "nextToken": null
      }
    }''';
  });

  group('Ticker repository tests ', () {
    test('Must return a success ticker fetch response', () async {
      when(() => dataSource.getAllTickers()).thenAnswer(
        (_) async => GraphQLResponse(data: tDataSuccess, errors: []),
      );

      final result = await repository.getAllTickers();

      expect(result.isRight(), true);
      verify(() => dataSource.getAllTickers()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed ticker fetch response', () async {
      when(() => dataSource.getAllTickers()).thenAnswer(
        (_) async => GraphQLResponse(data: tDataError, errors: []),
      );

      final result = await repository.getAllTickers();

      expect(result.isLeft(), true);
      verify(() => dataSource.getAllTickers()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a successful fetch ticker live data response', () async {
      when(() => dataSource.getTickerStream(
            any(),
            any(),
          )).thenAnswer(
        (_) async => stream,
      );

      await repository.getTickerUpdates(
        '',
        '',
        (_) {},
        (_) {},
      );

      verify(() => dataSource.getTickerStream('', '')).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
