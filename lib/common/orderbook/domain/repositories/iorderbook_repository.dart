import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';

abstract class IOrderbookRepository {
  Future<Either<ApiError, OrderbookEntity>> getOrderbookData(
    String leftTokenId,
    String rightTokenId,
  );
  Future<Either<ApiError, void>> getOrderbookLiveData(
    String leftTokenId,
    String rightTokenId,
    Function(OrderbookEntity) onMsgReceived,
    Function(Object) onMsgError,
  );
}
