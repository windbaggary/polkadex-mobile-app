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
    final listAskData = (map['ask'] as List);
    final listBidData = (map['bid'] as List);
    double? askCumulativeAmount;
    double? bidCumulativeAmount;

    listAskData.sort(
        (a, b) => double.parse(a['price']).compareTo(double.parse(b['price'])));
    listBidData.sort(
        (a, b) => double.parse(b['price']).compareTo(double.parse(a['price'])));

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
