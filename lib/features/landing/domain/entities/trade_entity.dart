import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/domain/entities/fee_entity.dart';
import 'package:polkadex/features/landing/utils/token_utils.dart';

abstract class TradeEntity extends Equatable {
  const TradeEntity({
    required this.id,
    required this.timestamp,
    required this.mainAcc,
    required this.baseAsset,
    required this.quoteAsset,
    required this.orderId,
    required this.orderSide,
    required this.orderType,
    required this.price,
    required this.amount,
    required this.fee,
  });

  final String id;
  final DateTime timestamp;
  final String mainAcc;
  final String baseAsset;
  final String quoteAsset;
  final String orderId;
  final EnumOrderTypes? orderType;
  final EnumBuySell? orderSide;
  final String price;
  final String amount;
  final FeeEntity fee;

  String get iAmount => "$amount ${TokenUtils.tokenIdToAcronym(baseAsset)}";

  String get iFormattedDate {
    return DateFormat("MMM dd, yyyy HH:mm:ss").format(timestamp);
  }

  String get iPrice => "$price ${TokenUtils.tokenIdToAcronym(quoteAsset)}";

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

  String get iTokenPairName => 'tokenPairName';

  EnumOrderTypes? get iEnumOrderType => orderType;

  @override
  List<Object?> get props => [
        id,
        timestamp,
        mainAcc,
        baseAsset,
        quoteAsset,
        orderId,
        orderSide,
        orderType,
        price,
        amount,
        fee,
      ];
}
