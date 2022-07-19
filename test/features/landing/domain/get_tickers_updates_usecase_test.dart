import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/domain/repositories/iticker_repository.dart';
import 'package:polkadex/features/landing/domain/usecases/get_ticker_updates_usecase.dart';

class _TickerRepositoryMock extends Mock implements ITickerRepository {}

void main() {
  late GetTickerUpdatesUseCase _usecase;
  late _TickerRepositoryMock _repository;

  setUp(() {
    _repository = _TickerRepositoryMock();
    _usecase = GetTickerUpdatesUseCase(tickerRepository: _repository);
  });

  group('GetTickerUpdatesUseCase tests', () {
    test(
      "must get ticker live data successfully",
      () async {
        // arrange
        when(() => _repository.getTickerUpdates(
              any(),
              any(),
              any(),
              any(),
            )).thenAnswer(
          (_) async => Right(null),
        );
        // act
        await _usecase(
          leftTokenId: '',
          rightTokenId: '',
          onMsgReceived: (_) {},
          onMsgError: (_) {},
        );
        // assert

        verify(() => _repository.getTickerUpdates(
              any(),
              any(),
              any(),
              any(),
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
