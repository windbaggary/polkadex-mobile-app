import 'package:equatable/equatable.dart';

import 'fee_entity.dart';

abstract class WithdrawEntity extends Equatable {
  const WithdrawEntity({
    required this.id,
    required this.txid,
    required this.timestamp,
    required this.from,
    required this.to,
    required this.transactionType,
    required this.amount,
    required this.currency,
    required this.status,
    required this.fee,
  });

  final String id;
  final String txid;
  final DateTime timestamp;
  final String from;
  final String to;
  final String transactionType;
  final double amount;
  final String currency;
  final String status;
  final FeeEntity fee;

  @override
  List<Object> get props => [
        id,
        txid,
        timestamp,
        from,
        to,
        transactionType,
        amount,
        currency,
        status,
        fee,
      ];
}
