import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class GetOrdersUpdatesUseCase {
  GetOrdersUpdatesUseCase({
    required ITradeRepository tradeRepository,
  }) : _tradeRepository = tradeRepository;

  final ITradeRepository _tradeRepository;

  Future<void> call({
    required String address,
    required Function(OrderEntity) onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _tradeRepository.fetchOrdersUpdates(
      address,
      onMsgReceived,
      onMsgError,
    );
  }
}
