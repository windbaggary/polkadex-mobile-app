import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:polkadex/utils/enums.dart';

/// The basic coint model over all the features
class BasicCoinListModel {
  final String imgAsset;
  final String code;
  final String token;
  final String pair;
  final String amount;
  final double _percentage;
  final String name;

  final EnumBuySell buySell;
  final double _volume;

  BasicCoinListModel({
    @required this.name,
    @required this.imgAsset,
    @required this.code,
    @required this.token,
    @required this.pair,
    @required this.amount,
    @required double percentage,
    @required this.buySell,
    double volume,
  })  : _volume = volume,
        _percentage = percentage;

  bool isFavorite = false;

  String get volume => NumberFormat().format(_volume);

  String get percentage {
    String sign = "";
    switch (buySell) {
      case EnumBuySell.buy:
        sign = "+";
        break;
      case EnumBuySell.sell:
        sign = "-";

        break;
    }
    return sign + _percentage.toStringAsFixed(2);
  }

  Color get color {
    switch (buySell) {
      case EnumBuySell.buy:
        return color0CA564;
      case EnumBuySell.sell:
        return colorE6007A;
    }
    return Colors.transparent;
  }
}
