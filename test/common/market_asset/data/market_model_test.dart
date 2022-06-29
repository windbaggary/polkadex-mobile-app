import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/market_asset/data/models/market_model.dart';
import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';

void main() {
  late MarketModel tMarket;

  setUp(() {
    tMarket = MarketModel(
      assetId: 'asset',
      baseAsset: {'polkadex': null},
      quoteAsset: {'assetId': 0},
      minTradeAmount: 1,
      maxTradeAmount: '0x32874672354',
      minOrderQty: 1,
      maxOrderQty: '0x32874672354',
      minDepth: 1,
      maxSpread: 9001,
    );
  });

  test('MarketModel must be a MarketEntity', () async {
    expect(tMarket, isA<MarketEntity>());
  });
}
