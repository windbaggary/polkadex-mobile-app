import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class OrderEntity extends Equatable {
  const OrderEntity({
    required this.mainAccount,
    required this.tradeId,
    required this.time,
    required this.baseAsset,
    required this.quoteAsset,
    required this.orderSide,
    required this.orderType,
    required this.status,
    required this.price,
    required this.qty,
    this.avgFilledPrice,
    this.filledQuantity,
    this.fee,
  });

  final String mainAccount;
  final String tradeId;
  final DateTime time;
  final String baseAsset;
  final String quoteAsset;
  final EnumBuySell orderSide;
  final EnumOrderTypes orderType;
  final String status;
  final String price;
  final String qty;
  final String? avgFilledPrice;
  final String? filledQuantity;
  final String? fee;

  String get iFormattedDate {
    return DateFormat("MMM dd, yyyy HH:mm:ss").format(time);
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
        mainAccount,
        tradeId,
        time,
        baseAsset,
        quoteAsset,
        orderSide,
        orderType,
        status,
        price,
        qty,
        avgFilledPrice,
        filledQuantity,
        fee,
      ];
}
