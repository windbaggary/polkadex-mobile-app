import 'package:flutter/material.dart';
import 'package:polkadex/common/dummy_providers/dummy_lists.dart';
import 'package:polkadex/features/landing/data/models/home_models.dart';

/// The provider to manage the functionality of token pair selection
class TradeTabViewProvider extends ChangeNotifier {
  int orderSideIndex = 0;
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
