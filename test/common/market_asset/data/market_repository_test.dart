import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/market_asset/data/datasources/market_remote_datasource.dart';
import 'package:polkadex/common/market_asset/data/repositories/market_repository.dart';

class _MockMarketRemoteDatasource extends Mock
    implements MarketRemoteDatasource {}

void main() {
  late _MockMarketRemoteDatasource dataSource;
  late MarketRepository repository;

  setUp(() {
    dataSource = _MockMarketRemoteDatasource();
    repository = MarketRepository(marketRemoteDatasource: dataSource);
  });

  group('Orderbook repository tests', () {
    test('Must return a successful fetch market details response', () async {
      when(() => dataSource.getMarkets()).thenAnswer(
        (_) async => [
          {
            'assetId': 'asset',
            'baseAsset': {'polkadex': null},
            'quoteAsset': {'assetId': 0},
            'minTradeAmount': 1,
            'maxTradeAmount': '0x32874672354',
            'minOrderQty': 1,
            'maxOrderQty': '0x32874672354',
            'minDepth': 1,
            'maxSpread': 9001,
          }
        ],
      );

      final result = await repository.getMarkets();

      expect(result.isRight(), true);
      verify(() => dataSource.getMarkets()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return an empty fetch market details response', () async {
      when(() => dataSource.getMarkets()).thenAnswer(
        (_) async => [],
      );

      final result = await repository.getMarkets();

      expect(result.isLeft(), true);
      verify(() => dataSource.getMarkets()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return an empty fetch market details response', () async {
      when(() => dataSource.getMarkets()).thenAnswer(
        (_) async => throw Error(),
      );

      final result = await repository.getMarkets();

      expect(result.isLeft(), true);
      verify(() => dataSource.getMarkets()).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
