import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/trades/data/models/trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

void main() {
  late TradeModel tTrade;

  setUp(() {
    tTrade = TradeModel(
      mainAccount: "k9o1dxJxQE8Zwm5Fy",
      txnType: EnumTradeTypes.deposit,
      asset: '1',
      amount: '10',
      fee: '10.0',
      status: 'PartiallyFilled',
      time: DateTime.now(),
    );
  });

  test('TradeModel must be a TradeEntity', () {
    expect(tTrade, isA<TradeEntity>());
  });
}
