import 'package:flutter/material.dart';
import 'package:polkadex/features/landing/data/models/home_models.dart';

/// The provider for handling the favourite functionality
class ExchangeTabViewProvider extends ChangeNotifier {
  bool _isFavoriteFilter = false;

  bool get isFavoriteFilter => _isFavoriteFilter;

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
