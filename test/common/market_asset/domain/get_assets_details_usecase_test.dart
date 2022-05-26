import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/market_asset/data/models/asset_model.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/market_asset/domain/repositories/iasset_repository.dart';
import 'package:polkadex/common/market_asset/domain/usecases/get_assets_details_usecase.dart';
import 'package:polkadex/common/network/error.dart';

class _AssetRepositoryMock extends Mock implements IAssetRepository {}

void main() {
  late GetAssetsDetailsUseCase _usecase;
  late _AssetRepositoryMock _repository;
  late AssetEntity tAsset;

  setUp(() {
    _repository = _AssetRepositoryMock();
    _usecase = GetAssetsDetailsUseCase(assetRepository: _repository);
    tAsset = AssetModel(
      assetId: '1',
      deposit: '18,000,000,000,000',
      name: 'TBTC',
      symbol: 'TBTC',
      decimals: '12',
      isFrozen: false,
    );
  });

  group('GetAssetsDetailsUseCase tests', () {
    test(
      "must fetch asset details data",
      () async {
        // arrange
        when(() => _repository.getAssetsDetails()).thenAnswer(
          (_) async => Right([tAsset]),
        );
        // act
        final result = await _usecase();

        expect(result.isRight(), true);
        verify(() => _repository.getAssetsDetails()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to fetch asset details data",
      () async {
        // arrange
        when(() => _repository.getAssetsDetails()).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase();
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.getAssetsDetails()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
