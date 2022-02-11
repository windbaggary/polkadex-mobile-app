import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/enums.dart';

abstract class OrderEntity extends Equatable {
  const OrderEntity({
    required this.uuid,
    required this.type,
    required this.amount,
    required this.price,
    required this.dateTime,
    required this.amountCoin,
    required this.priceCoin,
    required this.orderType,
    required this.tokenPairName,
  });

  final String uuid;
  final EnumBuySell type;
  final String amount;
  final String price;
  final DateTime dateTime;
  final String amountCoin;
  final String priceCoin;
  final EnumOrderTypes orderType;
  final String tokenPairName;

  String get iAmount => "$amount $amountCoin";

  String get iFormattedDate {
    return DateFormat("MMM dd, yyyy HH:mm:ss").format(dateTime);
  }

  String get iPrice => "$price $priceCoin";

  String get iType {
    switch (type) {
      case EnumBuySell.buy:
        return "Buy";
      case EnumBuySell.sell:
        return "Sell";
    }
  }

  EnumBuySell get iEnumType => type;

  String get iOrderTypeName {
    switch (orderType) {
      case EnumOrderTypes.market:
        return "Market";
      case EnumOrderTypes.limit:
        return "Limit";
      case EnumOrderTypes.stop:
        return "Stop";
    }
  }

  String get iTokenPairName => tokenPairName;

  EnumOrderTypes get iEnumOrderType => orderType;

  @override
  List<Object> get props => [
        uuid,
        type,
        amount,
        price,
        dateTime,
        amountCoin,
        priceCoin,
        orderType,
        tokenPairName,
      ];
}
