import 'package:polkadex/features/landing/data/models/home_models.dart';
import 'package:polkadex/common/utils/enums.dart';

/// The dummy data
final basicCoinDummyList = <BasicCoinListModel>[
  BasicCoinListModel(
    baseTokenId: '0',
    pairTokenId: '1',
    amount: "\$476,876",
    percentage: 13.09,
    buySell: EnumBuySell.sell,
    volume: 800108,
  ),
  BasicCoinListModel(
    baseTokenId: '1',
    pairTokenId: '0',
    amount: "\$476,876",
    percentage: 7.5,
    buySell: EnumBuySell.buy,
    volume: 264450,
  ),
];
