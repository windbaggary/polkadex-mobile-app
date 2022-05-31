import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';

class AssetModel extends AssetEntity {
  const AssetModel({
    required String assetId,
    required String deposit,
    required String name,
    required String symbol,
    required String decimals,
    required bool isFrozen,
  }) : super(
          assetId: assetId,
          deposit: deposit,
          name: name,
          symbol: symbol,
          decimals: decimals,
          isFrozen: isFrozen,
        );

  factory AssetModel.fromJson(Map<String, dynamic> map) {
    return AssetModel(
      assetId: map['assetId'],
      deposit: map['deposit'],
      name: map['name'],
      symbol: map['symbol'],
      decimals: map['decimals'],
      isFrozen: map['isFrozen'],
    );
  }
}
