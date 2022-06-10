import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class OrderEntity extends Equatable {
  const OrderEntity({
    required this.orderId,
    required this.amount,
    required this.price,
    required this.orderSide,
    required this.orderType,
    required this.timestamp,
    required this.baseAsset,
    required this.quoteAsset,
    required this.status,
  });

  final String orderId;
  final String amount;
  final String price;
  final EnumBuySell? orderSide;
  final EnumOrderTypes? orderType;
  final DateTime timestamp;
  final String baseAsset;
  final String quoteAsset;
  final EnumOrderStatus? status;

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

  EnumBuySell? get iEnumType => orderSide;

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
        orderId,
        amount,
        price,
        orderSide,
        orderType,
        timestamp,
        baseAsset,
        quoteAsset,
        status,
      ];
}
