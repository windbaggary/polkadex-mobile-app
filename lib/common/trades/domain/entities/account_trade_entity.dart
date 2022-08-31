import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class AccountTradeEntity extends Equatable {
  const AccountTradeEntity({
    required this.txnType,
    required this.asset,
    required this.amount,
    required this.fee,
    required this.status,
    required this.time,
  });

  final EnumTradeTypes txnType;
  final String asset;
  final double amount;
  final String fee;
  final String status;
  final DateTime time;

  @override
  List<Object?> get props => [
        txnType,
        asset,
        amount,
        fee,
        status,
        time,
      ];
}
