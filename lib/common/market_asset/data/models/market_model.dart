import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';

class MarketModel extends MarketEntity {
  const MarketModel({
    required String assetId,
    required Map<String, dynamic> baseAsset,
    required Map<String, dynamic> quoteAsset,
    required int minTradeAmount,
    required String maxTradeAmount,
    required int minOrderQty,
    required String maxOrderQty,
    required int minDepth,
    required int maxSpread,
  }) : super(
          assetId: assetId,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          minTradeAmount: minTradeAmount,
          maxTradeAmount: maxTradeAmount,
          minOrderQty: minOrderQty,
          maxOrderQty: maxOrderQty,
          minDepth: minDepth,
          maxSpread: maxSpread,
        );

  factory MarketModel.fromJson(Map<String, dynamic> map) {
    return MarketModel(
      assetId: map['assetId'],
      baseAsset: map['baseAsset'],
      quoteAsset: map['quoteAsset'],
      minTradeAmount: map['minTradeAmount'],
      maxTradeAmount: map['maxTradeAmount'],
      minOrderQty: map['minOrderQty'],
      maxOrderQty: map['maxOrderQty'],
      minDepth: map['minDepth'],
      maxSpread: map['maxSpread'],
    );
  }
}
