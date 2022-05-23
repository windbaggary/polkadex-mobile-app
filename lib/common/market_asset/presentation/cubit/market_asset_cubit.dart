import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'market_asset_state.dart';

class MarketAssetCubit extends Cubit<MarketAssetState> {
  MarketAssetCubit() : super(MarketAssetInitial());

  final Map<String, dynamic> markets = {};

  Future<void> getMarkets() async {}
}
