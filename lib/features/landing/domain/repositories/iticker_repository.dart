import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';

abstract class ITickerRepository {
  Future<Either<ApiError, Map<String, TickerEntity>>> getAllTickers();
  Future<void> getTickerUpdates(
    String leftTokenId,
    String rightTokenId,
    Function(TickerEntity) onMsgReceived,
    Function(Object) onMsgError,
  );
}
