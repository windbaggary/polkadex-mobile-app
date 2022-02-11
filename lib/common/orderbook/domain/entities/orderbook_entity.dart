import 'package:equatable/equatable.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';

abstract class OrderbookEntity extends Equatable {
  const OrderbookEntity({
    required this.baseAsset,
    required this.quoteAsset,
    required this.timestamp,
    required this.ask,
    required this.bid,
  });

  final String baseAsset;
  final String quoteAsset;
  final DateTime timestamp;
  final List<OrderbookItemEntity> ask;
  final List<OrderbookItemEntity> bid;

  @override
  List<Object> get props => [
        baseAsset,
        quoteAsset,
        timestamp,
        ask,
        bid,
      ];
}
