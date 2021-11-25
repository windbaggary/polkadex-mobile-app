import 'package:flutter/material.dart';
import 'package:polkadex/common/dummy_providers/dummy_lists.dart';
import 'package:polkadex/features/landing/data/models/home_models.dart';

/// The provider for handling the favourite functionality
class ExchangeTabViewProvider extends ChangeNotifier {
  final _list = _generateList();
  bool _isFavoriteFilter = false;

  bool get isFavoriteFilter => _isFavoriteFilter;

  List<BasicCoinListModel> get list {
    if (_isFavoriteFilter) {
      return _list.where((e) => e.isFavorite).toList();
    }

    return _list;
  }

  /// Enables the favourite filter. Setting this to true only displays
  /// favourite list items
  set isFavoriteFilter(bool value) {
    _isFavoriteFilter = value;
    notifyListeners();
  }

  /// Toggles the favourite filter
  void toggleFavoriteFilter() {
    _isFavoriteFilter = !_isFavoriteFilter;
    notifyListeners();
  }

  /// Set the item to favourite and notify the list
  bool toggleFavoriteItem(BasicCoinListModel model) {
    model.isFavorite = !model.isFavorite;
    notifyListeners();
    return model.isFavorite;
  }
}

/// Generate and shuffle the list
List<BasicCoinListModel> _generateList() {
  final list = basicCoinDummyList;
  list.shuffle();
  for (int i = 0; i < 5; i++) {
    list[i].isFavorite = true;
  }
  return list;
}
