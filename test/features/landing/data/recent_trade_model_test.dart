import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/trades/data/models/recent_trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';

void main() {
  late RecentTradeEntity tRecentTrade;

  setUp(() {
    tRecentTrade = RecentTradeModel(
      m: 'PDEX/1',
      qty: 1.0,
      price: 2.0,
      time: DateTime.now(),
    );
  });

  test('RecentTradeModel must be a RecentTradeEntity', () async {
    expect(tRecentTrade, isA<RecentTradeEntity>());
  });
}
