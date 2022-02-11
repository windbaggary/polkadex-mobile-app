import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';
import 'package:polkadex/common/orderbook/domain/repositories/iorderbook_repository.dart';

class FetchOrderbookDataUseCase {
  FetchOrderbookDataUseCase({
    required IOrderbookRepository orderbookRepository,
  }) : _orderbookRepository = orderbookRepository;

  final IOrderbookRepository _orderbookRepository;

  Future<Either<ApiError, OrderbookEntity>> call({
    required String leftTokenId,
    required String rightTokenId,
  }) async {
    return await _orderbookRepository.getOrderbookData(
      leftTokenId,
      rightTokenId,
    );
  }
}
