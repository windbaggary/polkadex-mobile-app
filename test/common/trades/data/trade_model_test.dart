import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/trades/data/models/trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

void main() {
  late TradeModel tTrade;

  setUp(() {
    tTrade = TradeModel(
      tradeId: '0',
      amount: "1",
      event: EnumTradeTypes.bid,
      timestamp: DateTime.now(),
      baseAsset: '0',
      status: 'PartiallyFilled',
      market: '0/1',
    );
  });

  test('TradeModel must be a TradeEntity', () {
    expect(tTrade, isA<TradeEntity>());
  });
}
