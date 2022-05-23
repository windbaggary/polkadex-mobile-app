part of 'market_asset_cubit.dart';

abstract class MarketAssetState extends Equatable {
  MarketAssetState({
    this.baseTokenId = '0',
    this.quoteTokenId = '0',
  });

  final String baseTokenId;
  final String quoteTokenId;

  @override
  List<Object> get props => [
        baseTokenId,
        quoteTokenId,
      ];
}

class MarketAssetInitial extends MarketAssetState {}

class MarketAssetLoaded extends MarketAssetState {
  MarketAssetLoaded({
    required String baseTokenId,
    required String quoteTokenId,
  }) : super(
          baseTokenId: baseTokenId,
          quoteTokenId: quoteTokenId,
        );
}
