import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';
import 'package:polkadex/common/orderbook/domain/repositories/iorderbook_repository.dart';

class FetchOrderbookLiveDataUseCase {
  FetchOrderbookLiveDataUseCase({
    required IOrderbookRepository orderbookRepository,
  }) : _orderbookRepository = orderbookRepository;

  final IOrderbookRepository _orderbookRepository;

  Future<Either<ApiError, void>> call({
    required String leftTokenId,
    required String rightTokenId,
    required Function(OrderbookEntity) onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _orderbookRepository.getOrderbookLiveData(
        leftTokenId, rightTokenId, onMsgReceived, onMsgError);
  }
}
