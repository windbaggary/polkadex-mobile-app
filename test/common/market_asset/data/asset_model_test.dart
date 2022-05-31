import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/market_asset/data/models/asset_model.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';

void main() {
  late AssetModel tAsset;

  setUp(() {
    tAsset = AssetModel(
      assetId: 'asset',
      deposit: '',
      name: 'asset',
      symbol: 'ASS',
      decimals: '22',
      isFrozen: false,
    );
  });

  test('AssetModel must be a AssetEntity', () async {
    expect(tAsset, isA<AssetEntity>());
  });
}
