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
  String get iAmount => "${this.amount ?? ""} ${this.amountCoin ?? ""}";

  @override
  String get iFormattedDate {
    if (this.dateTime != null) {
      return DateFormat("MMM dd, yyyy HH:mm:ss").format(this.dateTime);
    }
    return null;
  }

  @override
  String get iPrice => "${this.price ?? ""} ${this.priceCoin ?? ""}";

  @override
  String get iType {
    switch (this.type) {
      case EnumBuySell.Buy:
        return "Buy";
      case EnumBuySell.Sell:
        return "Sell";
    }
    return null;
  }

  @override
  EnumBuySell get iEnumType => this.type;

  @override
  String get iOrderTypeName {
    switch (this.orderType) {
      case EnumOrderTypes.Market:
        return "Market";
      case EnumOrderTypes.Limit:
        return "Limit";
      case EnumOrderTypes.Stop:
        return "Stop";
    }
    return null;
  }

  @override
  String get iTokenPairName => this.tokenPairName;

  @override
  EnumOrderTypes get iEnumOrderType => this.orderType;
}
