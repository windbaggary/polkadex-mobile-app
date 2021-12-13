import 'package:polkadex/features/coin/domain/entities/fee_entity.dart';
import 'package:polkadex/features/coin/domain/entities/withdraw_entity.dart';

class WithdrawModel extends WithdrawEntity {
  const WithdrawModel({
    required String id,
    required String txid,
    required DateTime timestamp,
    required String from,
    required String to,
    required String transactionType,
    required double amount,
    required String currency,
    required String status,
    required FeeEntity fee,
  }) : super(
          id: id,
          txid: txid,
          timestamp: timestamp,
          from: from,
          to: to,
          transactionType: transactionType,
          amount: amount,
          currency: currency,
          status: status,
          fee: fee,
        );
}
