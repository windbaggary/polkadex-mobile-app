import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';

class BalanceModel extends BalanceEntity {
  const BalanceModel({
    required Map free,
    required Map reserved,
  }) : super(
          free: free,
          reserved: reserved,
        );

  factory BalanceModel.fromJson(List<dynamic> listMap) {
    final mapFree = {};
    final mapReserved = {};

    for (var assetItem in listMap) {
      mapFree[assetItem['asset']] = assetItem['free'];
      mapReserved[assetItem['asset']] = assetItem['reserved'];
    }

    return BalanceModel(
      free: mapFree,
      reserved: mapReserved,
    );
  }

  factory BalanceModel.fromLiveJson(Map<String, dynamic> map) {
    final tradingPair = (map['trading_pair'] as String).split('/');
    final baseAsset = tradingPair[0];
    final quoteAsset = tradingPair[1];
    final mapFree = {};
    final mapReserved = {};

    mapFree[baseAsset] = map['update']['BalanceUpdate']['base_free'];
    mapReserved[baseAsset] = map['update']['BalanceUpdate']['base_reserved'];
    mapFree[quoteAsset] = map['update']['BalanceUpdate']['quote_free'];
    mapReserved[quoteAsset] = map['update']['BalanceUpdate']['quote_reserved'];

    return BalanceModel(
      free: mapFree,
      reserved: mapReserved,
    );
  }
}
