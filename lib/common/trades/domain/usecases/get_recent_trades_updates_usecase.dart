import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class GetRecentTradesUpdatesUseCase {
  GetRecentTradesUpdatesUseCase({
    required ITradeRepository tradeRepository,
  }) : _tradeRepository = tradeRepository;

  final ITradeRepository _tradeRepository;

  Future<void> call({
    required String market,
    required Function(RecentTradeEntity) onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _tradeRepository.fetchRecentTradesUpdates(
      market,
      onMsgReceived,
      onMsgError,
    );
  }
}
