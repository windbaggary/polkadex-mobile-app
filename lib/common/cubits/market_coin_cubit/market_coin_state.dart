part of 'market_coin_cubit.dart';

abstract class MarketCoinState extends Equatable {
  MarketCoinState({
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

class MarketCoinInitial extends MarketCoinState {}

class MarketCoinLoaded extends MarketCoinState {
  MarketCoinLoaded({
    required String baseTokenId,
    required String quoteTokenId,
  }) : super(
          baseTokenId: baseTokenId,
          quoteTokenId: quoteTokenId,
        );
}
