import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/common/trades/domain/usecases/get_recent_trades_updates_usecase.dart';

class _TradeRepositoryMock extends Mock implements ITradeRepository {}

void main() {
  late GetRecentTradesUpdatesUseCase _usecase;
  late _TradeRepositoryMock _repository;
  late String m;

  setUp(() {
    _repository = _TradeRepositoryMock();
    _usecase = GetRecentTradesUpdatesUseCase(tradeRepository: _repository);
    m = "PDEX-1";

    group('GetRecentTradesUpdatesUseCase tests', () {
      test(
        'must get recent trades updates',
        () async {
          // arrange
          when(() => _repository.fetchRecentTradesUpdates(any(), any(), any()))
              .thenAnswer(
            (_) async => Right(null),
          );
          // act
          await _usecase(
            market: m,
            onMsgReceived: (_) {},
            onMsgError: (_) {},
          );
          // assert

          verify(() => _repository.fetchRecentTradesUpdates(
                any(),
                any(),
                any(),
              )).called(1);
          verifyNoMoreInteractions(_repository);
        },
      );
    });
  });
}
