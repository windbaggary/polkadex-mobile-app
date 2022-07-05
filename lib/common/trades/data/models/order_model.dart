import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required String tradeId,
    required String amount,
    required String price,
    required EnumBuySell orderSide,
    required EnumOrderTypes orderType,
    required DateTime timestamp,
    required String baseAsset,
    required String quoteAsset,
    required String status,
    required String market,
  }) : super(
          tradeId: tradeId,
          amount: amount,
          price: price,
          orderSide: orderSide,
          orderType: orderType,
          timestamp: timestamp,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          status: status,
          market: market,
        );

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
      tradeId: map['id'],
      amount: map['qty'],
      price: map['price'],
      orderSide: StringUtils.enumFromString<EnumBuySell>(
          EnumBuySell.values, map['order_side'] == 'Bid' ? 'Buy' : 'Sell')!,
      orderType: StringUtils.enumFromString<EnumOrderTypes>(
          EnumOrderTypes.values, map['order_type'])!,
      timestamp: DateTime.fromMillisecondsSinceEpoch(int.parse(
              (map['timestamp'] as String).replaceAll('s', '').split('.')[0]) *
          1000),
      baseAsset: map['base_asset_type'],
      quoteAsset: map['quote_asset_type'],
      status: map['status'],
      market: '${map['base_asset_type']}/${map['quote_asset_type']}',
    );
  }
}
