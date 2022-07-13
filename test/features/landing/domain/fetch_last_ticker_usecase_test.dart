import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/models/ticker_model.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iticker_repository.dart';
import 'package:polkadex/features/landing/domain/usecases/get_all_tickers_usecase.dart';

class _TickerRepositoryMock extends Mock implements ITickerRepository {}

void main() {
  late GetAllTickersUseCase _usecase;
  late _TickerRepositoryMock _repository;
  late TickerEntity tTicker;

  setUp(() {
    _repository = _TickerRepositoryMock();
    _usecase = GetAllTickersUseCase(tickerRepository: _repository);
    tTicker = TickerModel(
      m: 'PDEX-1',
      priceChange24Hr: 1.0,
      priceChangePercent24Hr: 1.0,
      open: 1.0,
      close: 1.0,
      high: 1.0,
      low: 1.0,
      volumeBase24hr: 1.0,
      volumeQuote24Hr: 1.0,
    );
  });

  group('FetchLastTickerUseCase tests', () {
    test(
      "must get the last market ticker successfully",
      () async {
        // arrange
        when(() => _repository.getAllTickers()).thenAnswer(
          (_) async => Right({tTicker.m: tTicker}),
        );
        late Map<String, TickerEntity> tickerResult;
        // act
        final result = await _usecase();
        // assert

        result.fold(
          (_) => null,
          (ticker) => tickerResult = ticker,
        );

        expect(tickerResult, {tTicker.m: tTicker});
        verify(() => _repository.getAllTickers()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to get an account's balance",
      () async {
        // arrange
        when(() => _repository.getAllTickers()).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase();
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.getAllTickers()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
