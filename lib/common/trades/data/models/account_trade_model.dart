import 'dart:math';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class AccountTradeModel extends AccountTradeEntity {
  const AccountTradeModel({
    required EnumTradeTypes txnType,
    required String asset,
    required double amount,
    required String fee,
    required String status,
    required DateTime time,
  }) : super(
          txnType: txnType,
          asset: asset,
          amount: amount,
          fee: fee,
          status: status,
          time: time,
        );

  factory AccountTradeModel.fromJson(Map<String, dynamic> map) {
    return AccountTradeModel(
      txnType: StringUtils.enumFromString<EnumTradeTypes>(
          EnumTradeTypes.values, map['tt'])!,
      asset: map['a'],
      amount: (double.tryParse(map['q']) ?? 0.0) / pow(10, 12),
      fee: map['fee'],
      status: map['st'],
      time: DateTime.fromMillisecondsSinceEpoch(
        int.parse(map['t']),
      ),
    );
  }

  factory AccountTradeModel.fromUpdateJson(Map<String, dynamic> map) {
    return AccountTradeModel(
      txnType: StringUtils.enumFromString<EnumTradeTypes>(
          EnumTradeTypes.values, map['txn_type'])!,
      asset: map['asset'],
      amount: map['amount'] / pow(10, 12),
      fee: map['fee'].toString(),
      status: map['status'],
      time: DateTime.now(),
    );
  }
}
