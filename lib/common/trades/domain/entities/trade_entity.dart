import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class TradeEntity extends Equatable {
  const TradeEntity({
    required this.mainAccount,
    required this.txnType,
    required this.asset,
    required this.amount,
    required this.fee,
    required this.status,
    required this.time,
  });

  final String mainAccount;
  final EnumTradeTypes txnType;
  final String asset;
  final String amount;
  final String fee;
  final String status;
  final DateTime time;

  @override
  List<Object?> get props => [
        mainAccount,
        txnType,
        asset,
        amount,
        fee,
        status,
        time,
      ];
}
