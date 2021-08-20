import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/generated/l10n.dart';

abstract class ITradeOpenOrderModel {
  EnumBuySell get iEnumType;
  EnumOrderTypes get iEnumOrderType;
  String get iAmount;
  String get iPrice;
  String get iFormattedDate;
  String get iTokenPairName;
  String iType(BuildContext context);
  String iOrderTypeName(BuildContext context);
}

class TradeOpenOrderModel implements ITradeOpenOrderModel {
  final EnumBuySell type;
  final String? amount;
  final String price;
  final DateTime dateTime;
  final String? amountCoin;
  final String priceCoin;
  final EnumOrderTypes orderType;
  final String tokenPairName;

  TradeOpenOrderModel({
    required this.type,
    required this.amount,
    required this.price,
    required this.dateTime,
    required this.amountCoin,
    required this.priceCoin,
    required this.orderType,
    required this.tokenPairName,
  });

  @override
  String get iAmount => "${amount ?? ""} ${amountCoin ?? ""}";

  @override
  String get iFormattedDate {
    return DateFormat("MMM dd, yyyy HH:mm:ss").format(dateTime);
  }

  @override
  String get iPrice => "$price $priceCoin";

  @override
  String iType(BuildContext context) {
    switch (type) {
      case EnumBuySell.buy:
        return S.of(context).buy;
      case EnumBuySell.sell:
        return S.of(context).sell;
    }
  }

  @override
  EnumBuySell get iEnumType => type;

  @override
  String iOrderTypeName(BuildContext context) {
    switch (orderType) {
      case EnumOrderTypes.market:
        return S.of(context).market;
      case EnumOrderTypes.limit:
        return S.of(context).limit;
      case EnumOrderTypes.stop:
        return S.of(context).stop;
    }
  }

  @override
  String get iTokenPairName => tokenPairName;

  @override
  EnumOrderTypes get iEnumOrderType => orderType;
}
