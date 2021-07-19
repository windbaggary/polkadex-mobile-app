import 'package:flutter/material.dart';
import 'package:polkadex/common/dummy_providers/dummy_lists.dart';
import 'package:polkadex/features/landing/models/home_models.dart';
import 'package:polkadex/features/landing/models/trade_models.dart';
import 'package:polkadex/common/utils/enums.dart';

/// The provider to manage the functionality of token pair selection
class TradeTabViewProvider extends ChangeNotifier {
  final _listOrder = <ITradeOpenOrderModel>[
    TradeOpenOrderModel(
      type: EnumBuySell.buy,
      amount: '0.2900',
      price: '0.4423',
      dateTime: DateTime.now(),
      amountCoin: "DOT",
      priceCoin: "BTC",
      orderType: EnumOrderTypes.limit,
      tokenPairName: "DOT/BTC",
    )
  ];
  final _listOrderHistory = <ITradeOpenOrderModel>[
    TradeOpenOrderModel(
      type: EnumBuySell.buy,
      amount: '0.2900',
      price: '0.4423',
      dateTime: DateTime.now(),
      amountCoin: "DOT",
      priceCoin: "BTC",
      orderType: EnumOrderTypes.limit,
      tokenPairName: "DOT/BTC",
    )
  ];

  List<ITradeOpenOrderModel> get listOpenOrders => _listOrder;

  List<ITradeOpenOrderModel> get listOrdersHistory => _listOrderHistory;

  void addToListOrder(ITradeOpenOrderModel val) {
    _listOrder.add(val);
    notifyListeners();
  }

  void removeItem(ITradeOpenOrderModel item) {
    _listOrder.remove(item);
    _listOrderHistory.remove(item);

    notifyListeners();
  }
}

/// The provider to handle the selection of token pair
class TradeTabCoinProvider extends ChangeNotifier {
  BasicCoinListModel _tokenCoin = basicCoinDummyList[0];
  BasicCoinListModel? _pairCoin = basicCoinDummyList[1];

  BasicCoinListModel get tokenCoin => _tokenCoin;
  BasicCoinListModel? get pairCoin => _pairCoin;

  set tokenCoin(BasicCoinListModel value) {
    _tokenCoin = value;
    notifyListeners();
  }

  set pairCoin(BasicCoinListModel? value) {
    _pairCoin = value;
    notifyListeners();
  }
}
