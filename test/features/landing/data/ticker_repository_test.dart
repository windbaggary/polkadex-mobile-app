import 'dart:convert';

import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/data/datasources/ticker_remote_datasource.dart';
import 'package:polkadex/features/landing/data/repositories/ticker_repository.dart';

class _MockTickerRemoteDatasource extends Mock
    implements TickerRemoteDatasource {}

void main() {
  late _MockTickerRemoteDatasource dataSource;
  late TickerRepository repository;

  setUp(() {
    dataSource = _MockTickerRemoteDatasource();
    repository = TickerRepository(tickerRemoteDatasource: dataSource);
  });

  group('Ticker repository tests ', () {
    test('Must return a success ticker fetch response', () async {
      when(() => dataSource.getLastTickerData(any(), any())).thenAnswer(
        (_) async => Response(
            jsonEncode({
              "Fine":
                  "{\"timestamp\":1645100461,\"high\":\"\",\"low\":\"\",\"last\":\"\",\"previous_close\":\"2\",\"average\":\"\"}"
            }),
            200),
      );

      final result = await repository.getLastTicker(
        '0',
        '1',
      );

      expect(result.isRight(), true);
      verify(() => dataSource.getLastTickerData(
            '0',
            '1',
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return a failed ticker fetch response', () async {
      when(() => dataSource.getLastTickerData(any(), any())).thenAnswer(
        (_) async => Response('', 400),
      );

      final result = await repository.getLastTicker(
        '0',
        '1',
      );

      expect(result.isLeft(), true);
      verify(() => dataSource.getLastTickerData(
            '0',
            '1',
          )).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
