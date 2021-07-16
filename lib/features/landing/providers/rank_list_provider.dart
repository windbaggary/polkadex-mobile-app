import 'package:flutter/cupertino.dart';
import 'package:polkadex/dummy_providers/dummy_lists.dart';
import 'package:polkadex/features/landing/models/home_models.dart';
import 'package:polkadex/utils/enums.dart';

/// The provider to show the rank list based on the type selected
class HomeRankListProvider extends ChangeNotifier {
  EnumRankingListSorts _listType = EnumRankingListSorts.gainers;
  EnumRankingListSorts get listType => _listType;

  List<BasicCoinListModel> get list {
    final tmpList = List<BasicCoinListModel>.from(basicCoinDummyList);
    switch (_listType) {
      case EnumRankingListSorts.gainers:
        return tmpList.where((e) => e.buySell == EnumBuySell.buy).toList();
      case EnumRankingListSorts.losers:
        return tmpList.where((e) => e.buySell == EnumBuySell.sell).toList();
      case EnumRankingListSorts.vol:
        tmpList.sort((a, b) => b.volume.compareTo(a.volume));
        return tmpList;
    }
  }

  /// Set the filter type and notify. So the [list] will filtered
  set listType(EnumRankingListSorts val) {
    _listType = val;
    notifyListeners();
  }
}
