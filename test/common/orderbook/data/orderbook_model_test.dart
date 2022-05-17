import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/orderbook/data/models/orderbook_model.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';

void main() {
  late OrderbookModel tOrderbook;

  setUp(() {
    tOrderbook = OrderbookModel(
      ask: [],
      bid: [],
    );
  });

  test('OrderbookModel must be a OrderbookEntity', () async {
    expect(tOrderbook, isA<OrderbookEntity>());
  });
}
