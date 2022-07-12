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
      price: double.parse(map['price']),
      amount: double.parse(map['qty']),
    );
  }
}
