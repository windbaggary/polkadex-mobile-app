import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';

class OrderbookItemModel extends OrderbookItemEntity {
  const OrderbookItemModel(
      {required String id,
      required String baseAsset,
      required String quoteAsset,
      required EnumBuySell? orderSide,
      required double price,
      required double amount,
      required double cumulativeAmount})
      : super(
          id: id,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orderSide: orderSide,
          price: price,
          amount: amount,
          cumulativeAmount: cumulativeAmount,
        );

  factory OrderbookItemModel.fromJson(
    Map<String, dynamic> map,
    double? previousCumulativeAmount,
  ) {
    final amount = double.parse(map['amount']);

    return OrderbookItemModel(
      id: map['id'],
      baseAsset: map['base_asset'].toString(),
      quoteAsset: map['quote_asset'].toString(),
      orderSide: StringUtils.enumFromString<EnumBuySell>(
          EnumBuySell.values, map['order_side']),
      price: double.parse(map['price']),
      amount: double.parse(map['amount']),
      cumulativeAmount: (previousCumulativeAmount ?? 0.0) + amount,
    );
  }
}
