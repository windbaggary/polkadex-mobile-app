import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/orderbook/data/models/orderbook_item_model.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_item_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

void main() {
  late OrderbookItemModel tOrderbookItem;

  setUp(() {
    tOrderbookItem = OrderbookItemModel(
      id: '1',
      baseAsset: '0',
      quoteAsset: '1',
      orderSide: EnumBuySell.buy,
      price: 1.0,
      amount: 1.0,
      cumulativeAmount: 1.0,
    );
  });

  test('OrderbookItemModel must be a OrderbookItemEntity', () async {
    expect(tOrderbookItem, isA<OrderbookItemEntity>());
  });
}
