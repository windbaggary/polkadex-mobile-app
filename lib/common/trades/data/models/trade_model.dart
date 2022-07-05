import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class TradeModel extends TradeEntity {
  const TradeModel({
    required String mainAccount,
    required EnumTradeTypes txnType,
    required String asset,
    required String amount,
    required String fee,
    required String status,
    required DateTime time,
  }) : super(
          mainAccount: mainAccount,
          txnType: txnType,
          asset: asset,
          amount: amount,
          fee: fee,
          status: status,
          time: time,
        );

  factory TradeModel.fromJson(Map<String, dynamic> map) {
    return TradeModel(
      mainAccount: map['main_account'],
      txnType: StringUtils.enumFromString<EnumTradeTypes>(
          EnumTradeTypes.values, map['txn_type'])!,
      asset: map['asset'],
      amount: map['amount'],
      fee: map['fee'],
      status: map['status'],
      time: DateTime.parse(map['time']),
    );
  }
}
