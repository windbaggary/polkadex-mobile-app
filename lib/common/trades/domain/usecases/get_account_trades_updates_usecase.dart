import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class GetAccountTradesUpdatesUseCase {
  GetAccountTradesUpdatesUseCase({
    required ITradeRepository tradeRepository,
  }) : _tradeRepository = tradeRepository;

  final ITradeRepository _tradeRepository;

  Future<void> call({
    required String address,
    required Function(AccountTradeEntity) onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _tradeRepository.fetchAccountTradesUpdates(
      address,
      onMsgReceived,
      onMsgError,
    );
  }
}
