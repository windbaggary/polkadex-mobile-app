import 'package:polkadex/common/orderbook/domain/repositories/iorderbook_repository.dart';

class FetchOrderbookUpdatesUseCase {
  FetchOrderbookUpdatesUseCase({
    required IOrderbookRepository orderbookRepository,
  }) : _orderbookRepository = orderbookRepository;

  final IOrderbookRepository _orderbookRepository;

  Future<void> call({
    required String leftTokenId,
    required String rightTokenId,
    required Function(List<dynamic>, List<dynamic>) onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _orderbookRepository.getOrderbookUpdates(
        leftTokenId, rightTokenId, onMsgReceived, onMsgError);
  }
}
