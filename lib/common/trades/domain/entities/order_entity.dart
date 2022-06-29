import 'package:intl/intl.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class OrderEntity extends TradeEntity {
  const OrderEntity({
    required String tradeId,
    required String baseAsset,
    required String amount,
    required DateTime timestamp,
    required String status,
    required EnumTradeTypes event,
    required String market,
    required this.price,
    required this.orderSide,
    required this.orderType,
    required this.quoteAsset,
  }) : super(
          tradeId: tradeId,
          baseAsset: baseAsset,
          amount: amount,
          timestamp: timestamp,
          status: status,
          event: event,
          market: market,
        );

  final String price;
  final EnumBuySell orderSide;
  final EnumOrderTypes? orderType;
  final String quoteAsset;

  String get iFormattedDate {
    return DateFormat("MMM dd, yyyy HH:mm:ss").format(timestamp);
  }

  String get iType {
    switch (event) {
      case EnumTradeTypes.bid:
        return "Buy";
      case EnumTradeTypes.ask:
        return "Sell";
      default:
        return "";
    }
  }

  String get iOrderTypeName {
    switch (orderType) {
      case EnumOrderTypes.market:
        return "Market";
      case EnumOrderTypes.limit:
        return "Limit";
      case EnumOrderTypes.stop:
        return "Stop";
      default:
        return "";
    }
  }

  EnumOrderTypes? get iEnumOrderType => orderType;

  @override
  List<Object?> get props => [
        tradeId,
        amount,
        price,
        event,
        orderType,
        timestamp,
        baseAsset,
        quoteAsset,
        status,
      ];
}
