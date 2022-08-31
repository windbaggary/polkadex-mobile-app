import 'package:equatable/equatable.dart';

abstract class MarketEntity extends Equatable {
  const MarketEntity({
    required this.assetId,
    required this.baseAsset,
    required this.quoteAsset,
  });

  final String assetId;
  final Map<String, dynamic> baseAsset;
  final Map<String, dynamic> quoteAsset;

  @override
  List<Object> get props => [
        assetId,
        baseAsset,
        quoteAsset,
      ];
}
