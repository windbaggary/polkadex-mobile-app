import 'package:polkadex/features/trade/domain/entities/order_book_item_entity.dart';

class OrderBookItemModel extends OrderBookItemEntity {
  const OrderBookItemModel({
    required double amount,
    required double price,
    required double percentage,
  }) : super(
          amount: amount,
          price: price,
          percentage: percentage,
        );
}
