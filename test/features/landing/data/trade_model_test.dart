import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/models/fee_model.dart';
import 'package:polkadex/features/landing/data/models/trade_model.dart';
import 'package:polkadex/features/landing/domain/entities/trade_entity.dart';

void main() {
  late TradeModel tTrade;

  setUp(() {
    tTrade = TradeModel(
      id: '0',
      timestamp: DateTime.now(),
      mainAcc: "0",
      baseAsset: '0',
      quoteAsset: '1',
      orderId: '1',
      orderType: EnumOrderTypes.market,
      orderSide: EnumBuySell.buy,
      price: "50.0",
      amount: "1",
      fee: FeeModel(currency: '0', cost: '0'),
    );
  });

  test('TradeModel must be a TradeEntity', () {
    expect(tTrade, isA<TradeEntity>());
  });
}
