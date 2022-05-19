import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';
import 'package:polkadex/common/orderbook/data/models/orderbook_item_model.dart';

class OrderbookModel extends OrderbookEntity {
  const OrderbookModel({
    required List<OrderbookItemEntity> ask,
    required List<OrderbookItemEntity> bid,
  }) : super(
          ask: ask,
          bid: bid,
        );

  factory OrderbookModel.fromJson(Map<String, dynamic> map) {
    final listAskData = (map['asks'] as List);
    final listBidData = (map['bids'] as List);
    double? askCumulativeAmount;
    double? bidCumulativeAmount;

    listAskData.sort((a, b) => a[0].compareTo(b[0]));
    listBidData.sort((a, b) => b[0].compareTo(a[0]));

    final List<OrderbookItemEntity> dataAsk =
        List<OrderbookItemEntity>.generate(
      listAskData.length,
      (index) {
        final newItem = OrderbookItemModel.fromJson(
            listAskData[index], askCumulativeAmount);
        askCumulativeAmount = newItem.cumulativeAmount;

        return newItem;
      },
    ).toList();

    final List<OrderbookItemEntity> dataBid =
        List<OrderbookItemEntity>.generate(
      listBidData.length,
      (index) {
        final newItem = OrderbookItemModel.fromJson(
            listBidData[index], bidCumulativeAmount);
        bidCumulativeAmount = newItem.cumulativeAmount;

        return newItem;
      },
    ).toList();

    return OrderbookModel(
      ask: dataAsk,
      bid: dataBid,
    );
  }
}
