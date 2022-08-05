import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/domain/usecases/get_assets_details_usecase.dart';
import 'package:polkadex/common/market_asset/domain/usecases/get_markets_usecase.dart';

part 'market_asset_state.dart';

class MarketAssetCubit extends Cubit<MarketAssetState> {
  MarketAssetCubit({
    required GetMarketsUseCase getMarketsUseCase,
    required GetAssetsDetailsUseCase getAssetsDetailsUseCase,
  })  : _getMarketsUseCase = getMarketsUseCase,
        _getAssetsDetailsUseCase = getAssetsDetailsUseCase,
        super(MarketAssetInitial());

  final GetMarketsUseCase _getMarketsUseCase;
  final GetAssetsDetailsUseCase _getAssetsDetailsUseCase;

  final List<List<AssetEntity>> _marketsList = [];
  final Map<String, List<String>> _marketsMap = {};
  final Map<String, AssetEntity> _assets = {};

  List<List<AssetEntity>> get listAvailableMarkets => _marketsList;
  Map<String, AssetEntity> get mapAvailableAssets => _assets;

  AssetEntity get currentBaseAssetDetails {
    final currentState = state;

    return currentState is MarketAssetLoaded
        ? _assets[currentState.baseToken.assetId]!
        : _assets['PDEX']!;
  }

  AssetEntity get currentQuoteAssetDetails {
    final currentState = state;

    return currentState is MarketAssetLoaded
        ? _assets[currentState.quoteToken.assetId]!
        : _assets['PDEX']!;
  }

  String get currentMarketId {
    final currentState = state;

    return currentState is MarketAssetLoaded
        ? '${currentState.baseToken.assetId}-${currentState.quoteToken.assetId}'
        : '-';
  }

  AssetEntity getAssetDetailsById(String tokenId) {
    return _assets[tokenId] ?? _assets['PDEX']!;
  }

  Future<void> getMarkets() async {
    _assets.clear();
    _marketsList.clear();
    _marketsMap.clear();

    emit(MarketAssetLoading());

    final resultAssets = await _getAssetsDetailsUseCase();
    resultAssets.fold(
      (error) => emit(MarketAssetError(message: error.message)),
      (assets) {
        for (var asset in assets) {
          _assets[asset.assetId] = asset;
        }
      },
    );

    final resultMarkets = await _getMarketsUseCase();
    resultMarkets.fold(
      (error) => emit(MarketAssetError(message: error.message)),
      (markets) {
        for (var i = 0; i < markets.length; i++) {
          final baseAsset = getAssetDetailsById(
              (markets[i].baseAsset['asset'] ?? 'PDEX').toString());
          final quoteAsset = getAssetDetailsById(
              (markets[i].quoteAsset['asset'] ?? 'PDEX').toString());

          if (i == 0) {
            emit(
              MarketAssetLoaded(
                baseToken: baseAsset,
                quoteToken: quoteAsset,
              ),
            );
          }

          if (_marketsMap[baseAsset.assetId] == null) {
            _marketsMap[baseAsset.assetId] = [];
          }

          _marketsList.add([baseAsset, quoteAsset]);
          _marketsMap[baseAsset.assetId]?.add(quoteAsset.assetId);
        }
      },
    );
  }

  Future<void> changeSelectedMarket(
      AssetEntity baseAsset, AssetEntity quoteAsset) async {
    emit(
      MarketAssetLoaded(
        baseToken: baseAsset,
        quoteToken: quoteAsset,
      ),
    );
  }
}
