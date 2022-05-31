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
            'assetId': 'POLKADEX',
            'baseAsset': {'polkadex': null},
            'quoteAsset': {'asset': 1},
            'minimumTradeAmount': 1000000000000,
            'maximumTradeAmount': 1000000000000000,
            'minimumWithdrawalAmount': 1000000000000,
            'minimumDepositAmount': 1000000000000,
            'maximumWithdrawalAmount': 1000000000000000,
            'maximumDepositAmount': 1000000000000000,
            'baseWithdrawalFee': 1,
            'quoteWithdrawalFee': 1,
            'enclaveId': 'esm9HVPQhFDaBtpe5LsV25bDfron3sNkfgHecRRoDShvJUxcF'
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
