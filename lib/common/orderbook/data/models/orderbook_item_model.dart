import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';

class OrderbookItemModel extends OrderbookItemEntity {
  const OrderbookItemModel(
      {required double price,
      required double amount,
      required double cumulativeAmount})
      : super(
          price: price,
          amount: amount,
          cumulativeAmount: cumulativeAmount,
        );

  factory OrderbookItemModel.fromJson(
    Map<String, dynamic> map,
    double? previousCumulativeAmount,
  ) {
    return OrderbookItemModel(
      price: double.parse(map['price']),
      amount: double.parse(map['qty']),
      cumulativeAmount:
          (previousCumulativeAmount ?? 0.0) + double.parse(map['qty']),
    );
  }
}
