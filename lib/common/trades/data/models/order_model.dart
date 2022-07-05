import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String mainAccount,
    required String tradeId,
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
      mainAccount: map['main_account'],
      tradeId: map['id'],
      time: DateTime.parse(map['time']),
      baseAsset: assets[0],
      quoteAsset: assets[1],
      orderSide: StringUtils.enumFromString<EnumBuySell>(
          EnumBuySell.values, map['order_side'] == 'Bid' ? 'Buy' : 'Sell')!,
      orderType: StringUtils.enumFromString<EnumOrderTypes>(
          EnumOrderTypes.values, map['order_type'])!,
      status: map['status'],
      price: map['price'],
      qty: map['qty'],
      avgFilledPrice: map['avg_filled_price'],
      filledQuantity: map['filled_quantity'],
      fee: map['fee'],
    );
  }
}
