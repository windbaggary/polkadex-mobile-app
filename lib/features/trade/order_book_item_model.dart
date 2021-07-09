import 'package:flutter/material.dart';

class OrderBookItemModel {
  final String amount;
  final String price;
  final double percentage;

  const OrderBookItemModel({
    @required this.amount,
    @required this.price,
    @required this.percentage,
  });
}
