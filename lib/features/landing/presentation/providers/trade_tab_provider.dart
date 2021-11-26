import 'package:flutter/material.dart';
import 'package:polkadex/common/dummy_providers/dummy_lists.dart';
import 'package:polkadex/features/landing/data/models/home_models.dart';
import 'package:polkadex/features/landing/data/models/order_model.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';

/// The provider to manage the functionality of token pair selection
class TradeTabViewProvider extends ChangeNotifier {
  final _listOrder = <OrderEntity>[
    OrderModel(
      uuid: 'b47d2527-5a0c-11ea-822c-1831bf9834b0',
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
  final _listOrderHistory = <OrderEntity>[
    OrderModel(
      uuid: 'b47d2527-5a0c-11ea-822c-1831bf9834b1',
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

  List<OrderEntity> get listOpenOrders => _listOrder;

  List<OrderEntity> get listOrdersHistory => _listOrderHistory;

  void removeItem(OrderEntity item) {
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
