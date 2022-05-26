import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/domain/entities/fee_entity.dart';
import 'package:polkadex/common/orders/domain/entities/trade_entity.dart';

abstract class OrderEntity extends Equatable {
  const OrderEntity({
    required this.orderId,
    required this.mainAcc,
    required this.amount,
    required this.price,
    required this.orderSide,
    required this.orderType,
    required this.timestamp,
    required this.baseAsset,
    required this.quoteAsset,
    required this.status,
    required this.filledQty,
    required this.fee,
    required this.trades,
  });

  final String orderId;
  final String mainAcc;
  final String amount;
  final String price;
  final EnumBuySell? orderSide;
  final EnumOrderTypes? orderType;
  final DateTime timestamp;
  final String baseAsset;
  final String quoteAsset;
  final String status;
  final String filledQty;
  final FeeEntity fee;
  final List<TradeEntity> trades;

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
        mainAcc,
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
