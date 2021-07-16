import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/utils/enums.dart';

abstract class ITradeOpenOrderModel {
  String get iType;
  EnumBuySell get iEnumType;
  EnumOrderTypes get iEnumOrderType;
  String get iAmount;
  String get iPrice;
  String get iFormattedDate;
  String get iOrderTypeName;
  String get iTokenPairName;
}

class TradeOpenOrderModel implements ITradeOpenOrderModel {
  final EnumBuySell type;
  final String amount;
  final String price;
  final DateTime dateTime;
  final String amountCoin;
  final String priceCoin;
  final EnumOrderTypes orderType;
  final String tokenPairName;

  TradeOpenOrderModel({
    @required this.type,
    @required this.amount,
    @required this.price,
    @required this.dateTime,
    @required this.amountCoin,
    @required this.priceCoin,
    @required this.orderType,
    @required this.tokenPairName,
  });

  @override
  String get iAmount => "${amount ?? ""} ${amountCoin ?? ""}";

  @override
  String get iFormattedDate {
    if (dateTime != null) {
      return DateFormat("MMM dd, yyyy HH:mm:ss").format(dateTime);
    }
    return null;
  }

  @override
  String get iPrice => "${price ?? ""} ${priceCoin ?? ""}";

  @override
  String get iType {
    switch (type) {
      case EnumBuySell.buy:
        return "Buy";
      case EnumBuySell.sell:
        return "Sell";
    }
    return null;
  }

  @override
  EnumBuySell get iEnumType => type;

  @override
  String get iOrderTypeName {
    switch (orderType) {
      case EnumOrderTypes.market:
        return "Market";
      case EnumOrderTypes.limit:
        return "Limit";
      case EnumOrderTypes.stop:
        return "Stop";
    }
    return null;
  }

  @override
  String get iTokenPairName => tokenPairName;

  @override
  EnumOrderTypes get iEnumOrderType => orderType;
}
