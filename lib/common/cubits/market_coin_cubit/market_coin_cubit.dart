import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'market_coin_state.dart';

class MarketCoinCubit extends Cubit<MarketCoinState> {
  MarketCoinCubit() : super(MarketCoinInitial());

  final Map<String, dynamic> markets = {};

  Future<void> getMarkets() async {}
}
