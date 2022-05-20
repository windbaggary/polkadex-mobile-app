import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/enums.dart';

import 'package:polkadex/features/landing/utils/token_utils.dart';

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
  final String status;

  String get baseToken => TokenUtils.tokenIdToAcronym(baseAsset);

  String get iFormattedDate {
    return DateFormat("MMM dd, yyyy HH:mm:ss").format(timestamp);
  }

  String get quoteToken => TokenUtils.tokenIdToAcronym(quoteAsset);

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

  String get iTokenPairName =>
      "${TokenUtils.tokenIdToAcronym(baseAsset)}/${TokenUtils.tokenIdToAcronym(quoteAsset)}";

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
