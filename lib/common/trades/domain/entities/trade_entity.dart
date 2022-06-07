import 'package:equatable/equatable.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class TradeEntity extends Equatable {
  const TradeEntity({
    required this.tradeId,
    required this.assetId,
    required this.mainAccId,
    required this.amount,
    required this.timestamp,
    required this.status,
    required this.event,
    required this.market,
  });

  final String tradeId;
  final String assetId;
  final String mainAccId;
  final String amount;
  final DateTime timestamp;
  final String status;
  final EnumTradeTypes? event;
  final String market;

  @override
  List<Object?> get props => [
        tradeId,
        assetId,
        mainAccId,
        amount,
        timestamp,
        status,
        event,
        market,
      ];
}
