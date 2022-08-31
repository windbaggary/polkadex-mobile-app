import 'dart:math';

import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String mainAccount,
    required String tradeId,
    required String clientId,
    required DateTime time,
    required String baseAsset,
    required String quoteAsset,
    required EnumBuySell orderSide,
    required EnumOrderTypes orderType,
    required String status,
    required String price,
    required String qty,
    String? avgFilledPrice,
    String? filledQuantity,
    String? fee,
  }) : super(
          mainAccount: mainAccount,
          tradeId: tradeId,
          clientId: clientId,
          time: time,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orderSide: orderSide,
          orderType: orderType,
          status: status,
          price: price,
          qty: qty,
          avgFilledPrice: avgFilledPrice,
          filledQuantity: filledQuantity,
          fee: fee,
        );

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    final assets = map['m'].split('-');

    return OrderModel(
      mainAccount: map['u'],
      tradeId: map['id'],
      clientId: map['cid'],
      time: DateTime.fromMillisecondsSinceEpoch(int.parse(map['t'])),
      baseAsset: assets[0],
      quoteAsset: assets[1],
      orderSide: StringUtils.enumFromString<EnumBuySell>(
          EnumBuySell.values, map['s'] == 'Bid' ? 'Buy' : 'Sell')!,
      orderType: StringUtils.enumFromString<EnumOrderTypes>(
          EnumOrderTypes.values, map['ot'])!,
      status: map['st'],
      price: (int.parse(map['p'], radix: 16) / pow(10, 12)).toString(),
      qty: (int.parse(map['q'], radix: 16) / pow(10, 12)).toString(),
      avgFilledPrice:
          (int.parse(map['afp'], radix: 16) / pow(10, 12)).toString(),
      filledQuantity:
          (int.parse(map['fq'], radix: 16) / pow(10, 12)).toString(),
      fee: (int.parse(map['fee'], radix: 16) / pow(10, 12)).toString(),
    );
  }

  factory OrderModel.fromUpdateJson(Map<String, dynamic> map) {
    return OrderModel(
      mainAccount: map['user'],
      tradeId: map['id'],
      clientId: map['client_order_id'],
      time: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      baseAsset: map['pair']['base_asset'] == 'polkadex'
          ? 'PDEX'
          : map['pair']['base_asset']['asset'].toString(),
      quoteAsset: map['pair']['quote_asset'] == 'polkadex'
          ? 'PDEX'
          : map['pair']['quote_asset']['asset'].toString(),
      orderSide: StringUtils.enumFromString<EnumBuySell>(
          EnumBuySell.values, map['side'] == 'Bid' ? 'Buy' : 'Sell')!,
      orderType: StringUtils.enumFromString<EnumOrderTypes>(
          EnumOrderTypes.values, map['order_type'])!,
      status: map['status'],
      price: (map['price'] / pow(10, 12)).toString(),
      qty: (map['qty'] / pow(10, 12)).toString(),
      avgFilledPrice: (map['avg_filled_price'] / pow(10, 12)).toString(),
      filledQuantity: (map['filled_quantity'] / pow(10, 12)).toString(),
      fee: (map['fee'] / pow(10, 12)).toString(),
    );
  }

  OrderModel copyWith({
    String? mainAccount,
    String? tradeId,
    String? clientId,
    DateTime? time,
    String? baseAsset,
    String? quoteAsset,
    EnumBuySell? orderSide,
    EnumOrderTypes? orderType,
    String? status,
    String? price,
    String? qty,
    String? avgFilledPrice,
    String? filledQuantity,
    String? fee,
  }) {
    return OrderModel(
      mainAccount: mainAccount ?? this.mainAccount,
      tradeId: tradeId ?? this.tradeId,
      clientId: clientId ?? this.clientId,
      time: time ?? this.time,
      baseAsset: baseAsset ?? this.baseAsset,
      quoteAsset: quoteAsset ?? this.quoteAsset,
      orderSide: orderSide ?? this.orderSide,
      orderType: orderType ?? this.orderType,
      status: status ?? this.status,
      price: price ?? this.price,
      qty: qty ?? this.qty,
      avgFilledPrice: avgFilledPrice ?? this.avgFilledPrice,
      filledQuantity: filledQuantity ?? this.filledQuantity,
      fee: fee ?? this.fee,
    );
  }
}
