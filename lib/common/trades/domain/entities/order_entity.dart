import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class OrderEntity extends Equatable {
  const OrderEntity({
    required this.tradeId,
    required this.baseAsset,
    required this.amount,
    required this.timestamp,
    required this.status,
    required this.market,
    required this.price,
    required this.orderSide,
    required this.orderType,
    required this.quoteAsset,
  });

  final String tradeId;
  final String baseAsset;
  final String amount;
  final DateTime timestamp;
  final String status;
  final String market;
  final String price;
  final EnumBuySell orderSide;
  final EnumOrderTypes orderType;
  final String quoteAsset;

  String get iFormattedDate {
    return DateFormat("MMM dd, yyyy HH:mm:ss").format(timestamp);
  }

  String get iType {
    switch (orderSide) {
      case EnumBuySell.buy:
        return "Buy";
      case EnumBuySell.sell:
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
        orderType,
        timestamp,
        baseAsset,
        quoteAsset,
        status,
      ];
}
