import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/market_asset/data/models/market_model.dart';
import 'package:polkadex/common/market_asset/domain/entities/market_entity.dart';

void main() {
  late MarketModel tMarket;

  setUp(() {
    tMarket = MarketModel(
      assetId: 'asset',
      baseAsset: {'polkadex': null},
      quoteAsset: {'assetId': 0},
      minimumTradeAmount: 1,
      maximumTradeAmount: 22000000,
      minimumWithdrawalAmount: 1,
      minimumDepositAmount: 1,
      maximumWithdrawalAmount: 22000000,
      maximumDepositAmount: 22000000,
      baseWithdrawalFee: 1,
      quoteWithdrawalFee: 1,
      enclaveId: 'eOUFHjkh239ifjnfFDASk',
    );
  });

  test('MarketModel must be a MarketEntity', () async {
    expect(tMarket, isA<MarketEntity>());
  });
}
