import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';

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
  })  : this._volume = volume,
        this._percentage = percentage;

  bool isFavorite = false;

  String get volume => NumberFormat().format(this._volume);

  String get percentage {
    String sign = "";
    switch (this.buySell) {
      case EnumBuySell.Buy:
        sign = "+";
        break;
      case EnumBuySell.Sell:
        sign = "-";

        break;
    }
    return sign + this._percentage.toStringAsFixed(2);
  }

  Color get color {
    switch (this.buySell) {
      case EnumBuySell.Buy:
        return color0CA564;
      case EnumBuySell.Sell:
        return colorE6007A;
    }
    return Colors.transparent;
  }
}
