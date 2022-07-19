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
}
