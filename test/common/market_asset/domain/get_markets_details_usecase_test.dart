import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/market_asset/data/models/market_model.dart';
import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';
import 'package:polkadex/common/market_asset/domain/repositories/imarket_repository.dart';
import 'package:polkadex/common/market_asset/domain/usecases/get_markets_usecase.dart';
import 'package:polkadex/common/network/error.dart';

class _MarketRepositoryMock extends Mock implements IMarketRepository {}

void main() {
  late GetMarketsUseCase _usecase;
  late _MarketRepositoryMock _repository;
  late MarketEntity tMarket;

  setUp(() {
    _repository = _MarketRepositoryMock();
    _usecase = GetMarketsUseCase(marketRepository: _repository);
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

  group('GetMarketsUseCase tests', () {
    test(
      "must fetch market details data",
      () async {
        // arrange
        when(() => _repository.getMarkets()).thenAnswer(
          (_) async => Right([tMarket]),
        );
        // act
        final result = await _usecase();

        expect(result.isRight(), true);
        verify(() => _repository.getMarkets()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to fetch market details data",
      () async {
        // arrange
        when(() => _repository.getMarkets()).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase();
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.getMarkets()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
