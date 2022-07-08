import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class GetRecentTradesUseCase {
  GetRecentTradesUseCase({
    required ITradeRepository tradeRepository,
  }) : _tradeRepository = tradeRepository;

  final ITradeRepository _tradeRepository;

  Future<Either<ApiError, List<RecentTradeEntity>>> call(
      {required String market}) async {
    return await _tradeRepository.fetchRecentTrades(market);
  }
}
