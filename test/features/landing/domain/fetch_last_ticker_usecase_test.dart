import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/models/ticker_model.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iticker_repository.dart';
import 'package:polkadex/features/landing/domain/usecases/fetch_last_ticker_usecase.dart';

class _TickerRepositoryMock extends Mock implements ITickerRepository {}

void main() {
  late FetchLastTickerUseCase _usecase;
  late _TickerRepositoryMock _repository;
  late TickerEntity tTicker;

  setUp(() {
    _repository = _TickerRepositoryMock();
    _usecase = FetchLastTickerUseCase(tickerRepository: _repository);
    tTicker = TickerModel(
      timestamp: DateTime.now(),
      high: '0',
      low: '0',
      last: '0',
      previousClose: '0',
      average: '0',
    );
  });

  group('FetchLastTickerUseCase tests', () {
    test(
      "must get the last market ticker successfully",
      () async {
        // arrange
        when(() => _repository.getLastTicker(
              any(),
              any(),
            )).thenAnswer(
          (_) async => Right(tTicker),
        );
        TickerEntity? tickerResult;
        // act
        final result = await _usecase(
          leftTokenId: '0',
          rightTokenId: '1',
        );
        // assert

        result.fold(
          (_) => null,
          (ticker) => tickerResult = ticker,
        );

        expect(tickerResult, tTicker);
        verify(() => _repository.getLastTicker(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to get an account's balance",
      () async {
        // arrange
        when(() => _repository.getLastTicker(any(), any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(
          leftTokenId: '0',
          rightTokenId: '1',
        );
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.getLastTicker(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
