import 'package:flutter/cupertino.dart';
import 'package:polkadex/common/dummy_providers/dummy_lists.dart';
import 'package:polkadex/features/landing/models/home_models.dart';
import 'package:polkadex/common/utils/enums.dart';

/// The provider to show the rank list based on the type selected
class HomeRankListProvider extends ChangeNotifier {
  EnumRankingListSorts _listType = EnumRankingListSorts.Gainers;
  EnumRankingListSorts get listType => this._listType;

  List<BasicCoinListModel> get list {
    final tmpList = List<BasicCoinListModel>.from(basicCoinDummyList);
    switch (this._listType) {
      case EnumRankingListSorts.Gainers:
        return tmpList.where((e) => e.buySell == EnumBuySell.Buy).toList();
      case EnumRankingListSorts.Losers:
        return tmpList.where((e) => e.buySell == EnumBuySell.Sell).toList();
      case EnumRankingListSorts.Vol:
        tmpList.sort((a, b) => b.volume.compareTo(a.volume));
        return tmpList;
    }
    return tmpList;
  }

  /// Set the filter type and notify. So the [list] will filtered
  set listType(EnumRankingListSorts val) {
    this._listType = val;
    notifyListeners();
  }
}
