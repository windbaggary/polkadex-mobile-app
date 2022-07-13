import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class GetAccountTradesUseCase {
  GetAccountTradesUseCase({
    required ITradeRepository tradeRepository,
  }) : _tradeRepository = tradeRepository;

  final ITradeRepository _tradeRepository;

  Future<Either<ApiError, List<AccountTradeEntity>>> call({
    required String address,
    required DateTime from,
    required DateTime to,
  }) async {
    return await _tradeRepository.fetchAccountTrades(address, from, to);
  }
}
