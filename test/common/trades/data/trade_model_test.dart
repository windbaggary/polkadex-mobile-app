import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/trades/data/models/account_trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/utils/enums.dart';

void main() {
  late AccountTradeModel tTrade;

  setUp(() {
    tTrade = AccountTradeModel(
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
    expect(tTrade, isA<AccountTradeEntity>());
  });
}
