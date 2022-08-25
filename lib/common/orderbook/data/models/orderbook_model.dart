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

  factory OrderbookModel.fromJson(List<dynamic> listMap) {
    final listAskData = listMap.where((item) => item['s'] == 'Ask').toList();
    final listBidData = listMap.where((item) => item['s'] == 'Bid').toList();

    final List<OrderbookItemEntity> dataAsk =
        List<OrderbookItemEntity>.generate(
      listAskData.length,
      (index) {
        final newItem = OrderbookItemModel.fromJson(listAskData[index]);

        return newItem;
      },
    ).toList();

    final List<OrderbookItemEntity> dataBid =
        List<OrderbookItemEntity>.generate(
      listBidData.length,
      (index) {
        final newItem = OrderbookItemModel.fromJson(listBidData[index]);

        return newItem;
      },
    ).toList();

    dataAsk.sort((a, b) => a.price.compareTo(b.price));
    dataBid.sort((a, b) => a.price.compareTo(b.price));

    return OrderbookModel(
      ask: dataAsk,
      bid: dataBid,
    );
  }

  OrderbookModel update(List<dynamic> listPuts, List<dynamic> listDels) {
    final tempBid = [...bid];
    final tempAsk = [...ask];

    for (var itemDel in listDels) {
      (itemDel['side'] == 'Bid' ? tempBid : tempAsk).removeWhere(
        (item) =>
            item.price ==
            double.parse(
              itemDel['price'],
            ),
      );
    }

    for (var itemPuts in listPuts) {
      final list = itemPuts['side'] == 'Bid' ? tempBid : tempAsk;

      final index = list
          .indexWhere((item) => item.price == double.parse(itemPuts['price']));

      if (index >= 0) {
        list[index] = OrderbookItemModel.fromJson(itemPuts);
      } else {
        list.add(OrderbookItemModel.fromJson(itemPuts));
      }
    }

    tempAsk.sort((a, b) => a.price.compareTo(b.price));
    tempBid.sort((a, b) => a.price.compareTo(b.price));

    return OrderbookModel(
      ask: tempAsk,
      bid: tempBid,
    );
  }
}
