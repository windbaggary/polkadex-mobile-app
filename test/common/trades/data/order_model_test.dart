import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';

void main() {
  late OrderModel tOrder;

  setUp(() {
    tOrder = OrderModel(
      mainAccount: 'asdfghj',
      tradeId: '0',
      clientId: '',
      qty: "1",
      price: "50.0",
      orderSide: EnumBuySell.buy,
      orderType: EnumOrderTypes.market,
      time: DateTime.now(),
      baseAsset: '0',
      quoteAsset: '1',
      status: 'OPEN',
    );
  });

  test('OrderModel must be a OrderEntity', () {
    expect(tOrder, isA<OrderEntity>());
  });
}
