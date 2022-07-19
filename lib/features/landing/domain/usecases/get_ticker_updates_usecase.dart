import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iticker_repository.dart';

class GetTickerUpdatesUseCase {
  GetTickerUpdatesUseCase({
    required ITickerRepository tickerRepository,
  }) : _tickerRepository = tickerRepository;

  final ITickerRepository _tickerRepository;

  Future<void> call({
    required String leftTokenId,
    required String rightTokenId,
    required Function(TickerEntity) onMsgReceived,
    required Function(Object) onMsgError,
  }) async {
    return await _tickerRepository.getTickerUpdates(
      leftTokenId,
      rightTokenId,
      onMsgReceived,
      onMsgError,
    );
  }
}
