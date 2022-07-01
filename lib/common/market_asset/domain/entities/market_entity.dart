import 'package:equatable/equatable.dart';

abstract class MarketEntity extends Equatable {
  const MarketEntity({
    required this.assetId,
    required this.baseAsset,
    required this.quoteAsset,
    required this.minTradeAmount,
    required this.maxTradeAmount,
    required this.minOrderQty,
    required this.maxOrderQty,
    required this.minDepth,
    required this.maxSpread,
  });

  final String assetId;
  final Map<String, dynamic> baseAsset;
  final Map<String, dynamic> quoteAsset;
  final int minTradeAmount;
  final int maxTradeAmount;
  final int minOrderQty;
  final int maxOrderQty;
  final int minDepth;
  final int maxSpread;

  @override
  List<Object> get props => [
        assetId,
        baseAsset,
        quoteAsset,
        minTradeAmount,
        maxTradeAmount,
        minOrderQty,
        maxOrderQty,
        minDepth,
        maxSpread,
      ];
}
