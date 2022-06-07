import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class TradeModel extends TradeEntity {
  const TradeModel({
    required String tradeId,
    required String baseAsset,
    required String quoteAsset,
    required String mainAccId,
    required String amount,
    required DateTime timestamp,
    required String status,
    required EnumTradeTypes? event,
    required String market,
  }) : super(
          tradeId: tradeId,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          mainAccId: mainAccId,
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
      quoteAsset: '',
      mainAccId: map['main_acc_id'],
      amount: map['amount'],
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'],
      event: StringUtils.enumFromString<EnumTradeTypes>(
          EnumTradeTypes.values, map['event']),
      market: map['market'],
    );
  }

  factory TradeModel.fromOrderJson(Map<String, dynamic> map) {
    return TradeModel(
      tradeId: map['id'],
      baseAsset: map['base_asset_type'],
      quoteAsset: map['quote_asset_type'],
      mainAccId: '',
      amount: map['qty'],
      timestamp: DateTime.parse(map['timestamp']),
      status: map['status'],
      event: StringUtils.enumFromString<EnumTradeTypes>(
          EnumTradeTypes.values, map['event']),
      market: '${map['base_asset_type']}/${map['quote_asset_type']}',
    );
  }
}
