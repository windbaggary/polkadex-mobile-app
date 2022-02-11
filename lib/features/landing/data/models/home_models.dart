import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/common/utils/enums.dart';

/// The basic coint model over all the features
class BasicCoinListModel {
  final String baseTokenId;
  final String pairTokenId;
  final String amount;
  final double _percentage;
  final EnumBuySell buySell;
  final double? _volume;

  BasicCoinListModel({
    required this.baseTokenId,
    required this.pairTokenId,
    required this.amount,
    required double percentage,
    required this.buySell,
    double? volume,
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
        return AppColors.color0CA564;
      case EnumBuySell.sell:
        return AppColors.colorE6007A;
    }
  }
}
