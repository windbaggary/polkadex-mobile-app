import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';

class OrderbookItemModel extends OrderbookItemEntity {
  const OrderbookItemModel({
    required double price,
    required double amount,
  }) : super(
          price: price,
          amount: amount,
        );

  factory OrderbookItemModel.fromJson(
    Map<String, dynamic> map,
  ) {
    return OrderbookItemModel(
      price: double.parse(map['p']),
      amount: double.parse(map['q']),
    );
  }

  factory OrderbookItemModel.fromUpdateJson(
    Map<String, dynamic> map,
  ) {
    return OrderbookItemModel(
      price: map['price'],
      amount: map['qty'],
    );
  }
}
