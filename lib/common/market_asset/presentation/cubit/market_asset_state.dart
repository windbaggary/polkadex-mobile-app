part of 'market_asset_cubit.dart';

abstract class MarketAssetState extends Equatable {
  MarketAssetState();

  @override
  List<Object> get props => [];
}

class MarketAssetInitial extends MarketAssetState {}

class MarketAssetLoaded extends MarketAssetState {
  MarketAssetLoaded({
    required this.baseToken,
    required this.quoteToken,
  });

  final AssetEntity baseToken;
  final AssetEntity quoteToken;

  @override
  List<Object> get props => [
        baseToken,
        quoteToken,
      ];
}

class MarketAssetError extends MarketAssetState {
  MarketAssetError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
