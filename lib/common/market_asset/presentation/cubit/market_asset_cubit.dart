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

  final Map<String, List<String>> _markets = {};
  final Map<String, AssetEntity> _assets = {};

  Future<void> getMarkets() async {
    _markets.clear();
    _assets.clear();

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
          final baseAssetId =
              (markets[i].baseAsset['asset'] ?? 'POLKADEX').toString();
          final quoteAssetId =
              (markets[i].quoteAsset['asset'] ?? 'POLKADEX').toString();

          if (i == 0) {
            emit(
              MarketAssetLoaded(
                baseTokenId: baseAssetId,
                quoteTokenId: quoteAssetId,
              ),
            );
          }

          if (_markets[baseAssetId] == null) {
            _markets[baseAssetId] = [];
          }

          _markets[baseAssetId]?.add(quoteAssetId);
        }
      },
    );
  }
}
