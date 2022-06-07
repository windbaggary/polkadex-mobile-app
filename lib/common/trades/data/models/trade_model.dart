import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class TradeModel extends TradeEntity {
  const TradeModel({
    required String tradeId,
    required String assetId,
    required String mainAccId,
    required String amount,
    required DateTime timestamp,
    required String status,
    required EnumTradeTypes? event,
    required String market,
  }) : super(
          tradeId: tradeId,
          assetId: assetId,
          mainAccId: mainAccId,
          amount: amount,
          timestamp: timestamp,
          status: status,
          event: event,
          market: market,
        );

  factory TradeModel.fromJson(Map<String, dynamic> map) {
    return TradeModel(
      tradeId: map['id'],
      assetId: map['asset_type'],
      mainAccId: map['main_acc_id'],
      amount: map['amount'],
      timestamp: map['timestamp'],
      status: map['status'],
      event: StringUtils.enumFromString<EnumTradeTypes>(
          EnumTradeTypes.values, map['event']),
      market: map['id'],
    );
  }
}
