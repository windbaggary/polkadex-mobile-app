import 'dart:math';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';

class BalanceModel extends BalanceEntity {
  const BalanceModel({
    required Map<String, double> free,
    required Map<String, double> reserved,
  }) : super(
          free: free,
          reserved: reserved,
        );

  factory BalanceModel.fromUpdateJson(List<dynamic> listMap) {
    final Map<String, double> mapFree = {};
    final Map<String, double> mapReserved = {};

    for (var assetItem in listMap) {
      mapFree[StringUtils.formatAssetString(assetItem['asset'])] =
          (assetItem['free'].toDouble() ?? 0.0) / pow(10, 12);
      mapReserved[StringUtils.formatAssetString(assetItem['asset'])] =
          (assetItem['reserved'].toDouble() ?? 0.0) / pow(10, 12);
    }

    return BalanceModel(
      free: mapFree,
      reserved: mapReserved,
    );
  }

  factory BalanceModel.fromJson(List<dynamic> listMap) {
    final Map<String, double> mapFree = {};
    final Map<String, double> mapReserved = {};

    for (var assetItem in listMap) {
      mapFree[StringUtils.formatAssetString(assetItem['a'])] =
          (double.tryParse(assetItem['f']) ?? 0.0) / pow(10, 12);
      mapReserved[StringUtils.formatAssetString(assetItem['a'])] =
          (double.tryParse(assetItem['r']) ?? 0.0) / pow(10, 12);
    }

    return BalanceModel(
      free: mapFree,
      reserved: mapReserved,
    );
  }
}
