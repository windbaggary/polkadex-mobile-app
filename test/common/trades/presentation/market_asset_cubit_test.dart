import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/market_asset/data/models/asset_model.dart';
import 'package:polkadex/common/market_asset/data/models/market_model.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';
import 'package:polkadex/common/market_asset/domain/usecases/get_assets_details_usecase.dart';
import 'package:polkadex/common/market_asset/domain/usecases/get_markets_usecase.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:test/test.dart';

class _MockGetMarketsUseCase extends Mock implements GetMarketsUseCase {}

class _MockGetAssetsDetailsUseCase extends Mock
    implements GetAssetsDetailsUseCase {}

void main() {
  late _MockGetMarketsUseCase _mockGetMarketsUseCase;
  late _MockGetAssetsDetailsUseCase _mockGetAssetsDetailsUseCase;
  late MarketAssetCubit cubit;
  late MarketEntity tMarket;
  late AssetEntity tAsset;

  setUp(() {
    _mockGetMarketsUseCase = _MockGetMarketsUseCase();
    _mockGetAssetsDetailsUseCase = _MockGetAssetsDetailsUseCase();

    cubit = MarketAssetCubit(
      getMarketsUseCase: _mockGetMarketsUseCase,
      getAssetsDetailsUseCase: _mockGetAssetsDetailsUseCase,
    );

    tMarket = MarketModel(
      assetId: 'asset',
      baseAsset: {'polkadex': null},
      quoteAsset: {'assetId': 0},
    );

    tAsset = AssetModel(
      assetId: 'PDEX',
      deposit: '18,000,000,000,000',
      name: 'TBTC',
      symbol: 'TBTC',
      decimals: '12',
      isFrozen: false,
    );
  });

  group(
    'MarketAssetCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, MarketAssetInitial());
      });

      blocTest<MarketAssetCubit, MarketAssetState>(
        'Market and Asset data fetched successfully',
        build: () {
          when(
            () => _mockGetMarketsUseCase(),
          ).thenAnswer(
            (_) async => Right([tMarket]),
          );
          when(
            () => _mockGetAssetsDetailsUseCase(),
          ).thenAnswer(
            (_) async => Right([tAsset]),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getMarkets();
        },
        expect: () => [
          MarketAssetLoading(),
          MarketAssetLoaded(
            baseToken: tAsset,
            quoteToken: tAsset,
          ),
        ],
      );

      blocTest<MarketAssetCubit, MarketAssetState>(
        'Market fetch successfull and Asset data fetch fail',
        build: () {
          when(
            () => _mockGetMarketsUseCase(),
          ).thenAnswer(
            (_) async => Left(ApiError(message: '')),
          );
          when(
            () => _mockGetAssetsDetailsUseCase(),
          ).thenAnswer(
            (_) async => Right([tAsset]),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getMarkets();
        },
        expect: () => [
          MarketAssetLoading(),
          MarketAssetError(message: ''),
        ],
      );

      blocTest<MarketAssetCubit, MarketAssetState>(
        'Market fetch fail and Asset data fetch successfull',
        build: () {
          when(
            () => _mockGetMarketsUseCase(),
          ).thenAnswer(
            (_) async => Right([tMarket]),
          );
          when(
            () => _mockGetAssetsDetailsUseCase(),
          ).thenAnswer(
            (_) async => Left(ApiError(message: '')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getMarkets();
        },
        expect: () => [
          MarketAssetLoading(),
          MarketAssetError(message: ''),
        ],
      );
    },
  );
}
