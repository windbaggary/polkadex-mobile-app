part of 'market_asset_cubit.dart';

abstract class MarketAssetState extends Equatable {
  MarketAssetState();

  @override
  List<Object> get props => [];
}

class MarketAssetInitial extends MarketAssetState {}

class MarketAssetLoaded extends MarketAssetState {
  MarketAssetLoaded({
    required this.baseTokenId,
    required this.quoteTokenId,
  });

  final String baseTokenId;
  final String quoteTokenId;

  @override
  List<Object> get props => [
        baseTokenId,
        quoteTokenId,
      ];
}

class MarketAssetError extends MarketAssetState {
  MarketAssetError({required this.message});

  final String message;

  @override
  List<Object> get props => [message];
}
