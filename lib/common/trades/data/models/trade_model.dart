import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class TradeModel extends TradeEntity {
  const TradeModel({
    required String tradeId,
    required String baseAsset,
    required String amount,
    required DateTime timestamp,
    required String status,
    required EnumTradeTypes event,
    required String market,
  }) : super(
          tradeId: tradeId,
          baseAsset: baseAsset,
          amount: amount,
          timestamp: timestamp,
          status: status,
          event: event,
          market: market,
        );

  factory TradeModel.fromDepWithJson(Map<String, dynamic> map) {
    return TradeModel(
      tradeId: map['id'],
      baseAsset: map['asset_type'],
      amount: map['amount'],
      timestamp: DateTime.now(),
      status: map['status'],
      event: StringUtils.enumFromString<EnumTradeTypes>(
          EnumTradeTypes.values, map['event'])!,
      market: map['market'],
    );
  }
}
