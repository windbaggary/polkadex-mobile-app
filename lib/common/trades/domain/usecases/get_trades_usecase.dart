import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class GetTradesUseCase {
  GetTradesUseCase({
    required ITradeRepository tradeRepository,
  }) : _tradeRepository = tradeRepository;

  final ITradeRepository _tradeRepository;

  Future<Either<ApiError, List<TradeEntity>>> call(
      {required String address}) async {
    return await _tradeRepository.fetchTrades(address);
  }
}
