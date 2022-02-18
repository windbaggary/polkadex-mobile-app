import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iticker_repository.dart';

class FetchLastTickerUseCase {
  FetchLastTickerUseCase({
    required ITickerRepository tickerRepository,
  }) : _tickerRepository = tickerRepository;

  final ITickerRepository _tickerRepository;

  Future<Either<ApiError, TickerEntity>> call({
    required String leftTokenId,
    required String rightTokenId,
  }) async {
    return await _tickerRepository.getLastTicker(
      leftTokenId,
      rightTokenId,
    );
  }
}
