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
    List listValues,
    double? previousCumulativeAmount,
  ) {
    return OrderbookItemModel(
      price: double.parse(listValues[0]),
      amount: double.parse(listValues[1]),
      cumulativeAmount:
          (previousCumulativeAmount ?? 0.0) + double.parse(listValues[1]),
    );
  }
}
