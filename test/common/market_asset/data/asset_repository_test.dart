import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/market_asset/data/datasources/asset_remote_datasource.dart';
import 'package:polkadex/common/market_asset/data/repositories/asset_repository.dart';

class _MockAssetRemoteDatasource extends Mock implements AssetRemoteDatasource {
}

void main() {
  late _MockAssetRemoteDatasource dataSource;
  late AssetRepository repository;

  setUp(() {
    dataSource = _MockAssetRemoteDatasource();
    repository = AssetRepository(assetRemoteDatasource: dataSource);
  });

  group('Orderbook repository tests', () {
    test('Must return a successful fetch asset details response', () async {
      when(() => dataSource.getAssetsDetails()).thenAnswer(
        (_) async => [
          {
            'assetId': '1',
            'deposit': '18,000,000,000,000',
            'name': 'TBTC',
            'symbol': 'TBTC',
            'decimals': '12',
            'isFrozen': false
          }
        ],
      );

      final result = await repository.getAssetsDetails();

      expect(result.isRight(), true);
      verify(() => dataSource.getAssetsDetails()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return an empty fetch asset details response', () async {
      when(() => dataSource.getAssetsDetails()).thenAnswer(
        (_) async => [],
      );

      final result = await repository.getAssetsDetails();

      expect(result.isLeft(), true);
      verify(() => dataSource.getAssetsDetails()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test('Must return an empty fetch asset details response', () async {
      when(() => dataSource.getAssetsDetails()).thenAnswer(
        (_) async => throw Error(),
      );

      final result = await repository.getAssetsDetails();

      expect(result.isLeft(), true);
      verify(() => dataSource.getAssetsDetails()).called(1);
      verifyNoMoreInteractions(dataSource);
    });
  });
}
