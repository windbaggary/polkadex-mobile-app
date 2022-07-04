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
    final listAskData = listMap.where((item) => item['side'] == 'Ask').toList();
    final listBidData = listMap.where((item) => item['side'] == 'Bid').toList();
    double? askCumulativeAmount;
    double? bidCumulativeAmount;

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

    dataAsk.sort((a, b) => a.price.compareTo(b.price));
    dataBid.sort((a, b) => a.price.compareTo(b.price));

    return OrderbookModel(
      ask: dataAsk,
      bid: dataBid,
    );
  }
}
