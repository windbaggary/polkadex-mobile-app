import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';

void main() {
  late OrderModel tOrder;

  setUp(() {
    tOrder = OrderModel(
      orderId: '0',
      amount: "1",
      price: "50.0",
      orderSide: EnumBuySell.buy,
      orderType: EnumOrderTypes.market,
      timestamp: DateTime.now(),
      baseAsset: '0',
      quoteAsset: '1',
      status: 'PartiallyFilled',
    );
  });

  test('OrderModel must be a OrderEntity', () {
    expect(tOrder, isA<OrderEntity>());
  });
}
