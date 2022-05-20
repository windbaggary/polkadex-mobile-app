import 'package:polkadex/common/utils/enums.dart';

import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String orderId,
    required String amount,
    required String price,
    required EnumBuySell? orderSide,
    required EnumOrderTypes? orderType,
    required DateTime timestamp,
    required String baseAsset,
    required String quoteAsset,
    required String status,
  }) : super(
          orderId: orderId,
          amount: amount,
          price: price,
          orderSide: orderSide,
          orderType: orderType,
          timestamp: timestamp,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          status: status,
        );

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
      orderId: map['id'],
      amount: map['qty'],
      price: map['price'],
      orderSide: StringUtils.enumFromString<EnumBuySell>(
          EnumBuySell.values, map['order_side'] == 'Ask' ? 'Buy' : 'Sell'),
      orderType: StringUtils.enumFromString<EnumOrderTypes>(
          EnumOrderTypes.values, map['order_type']),
      timestamp: DateTime.parse(map['timestamp']),
      baseAsset: map['base_asset'].toString(),
      quoteAsset: map['quote_asset'].toString(),
      status: map['status'],
    );
  }
}
