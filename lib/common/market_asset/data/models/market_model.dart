import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';

class MarketModel extends MarketEntity {
  const MarketModel({
    required String assetId,
    required Map<String, dynamic> baseAsset,
    required Map<String, dynamic> quoteAsset,
  }) : super(
          assetId: assetId,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
        );

  factory MarketModel.fromJson(Map<String, dynamic> map) {
    return MarketModel(
      assetId: map['assetId'],
      baseAsset: map['baseAsset'],
      quoteAsset: map['quoteAsset'],
    );
  }
}
