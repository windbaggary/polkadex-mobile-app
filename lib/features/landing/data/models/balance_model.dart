import 'package:mysql_client/mysql_client.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';

class BalanceModel extends BalanceEntity {
  const BalanceModel({
    required Map free,
    required Map reserved,
  }) : super(
          free: free,
          reserved: reserved,
        );

  factory BalanceModel.fromResultSet(IResultSet resultSet) {
    final listBalance = resultSet.rows.map((row) => row.assoc()).toList();

    final mapFree = {};
    final mapReserved = {};

    for (var assetMap in listBalance) {
      mapFree[assetMap['asset_type']] = assetMap['free_balance'];
      mapReserved[assetMap['asset_type']] = assetMap['reserved_balance'];
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

    mapFree[baseAsset] = map['update']['base_free'];
    mapReserved[baseAsset] = map['update']['base_reserved'];
    mapFree[quoteAsset] = map['update']['quote_free'];
    mapReserved[quoteAsset] = map['update']['quote_reserved'];

    return BalanceModel(
      free: mapFree,
      reserved: mapReserved,
    );
  }
}
