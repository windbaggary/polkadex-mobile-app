import 'package:equatable/equatable.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';

abstract class OrderbookEntity extends Equatable {
  const OrderbookEntity({
    required this.ask,
    required this.bid,
  });

  final List<OrderbookItemEntity> ask;
  final List<OrderbookItemEntity> bid;

  @override
  List<Object> get props => [
        ask,
        bid,
      ];
}
