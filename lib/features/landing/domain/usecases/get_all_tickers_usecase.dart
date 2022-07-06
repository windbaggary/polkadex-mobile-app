import 'package:dartz/dartz.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iticker_repository.dart';

class GetAllTickersUseCase {
  GetAllTickersUseCase({
    required ITickerRepository tickerRepository,
  }) : _tickerRepository = tickerRepository;

  final ITickerRepository _tickerRepository;

  Future<Either<ApiError, Map<String, TickerEntity>>> call() async {
    return await _tickerRepository.getAllTickers();
  }
}
