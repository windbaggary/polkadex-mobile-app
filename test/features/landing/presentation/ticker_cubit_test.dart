import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/models/ticker_model.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/get_all_tickers_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:test/test.dart';

class _MockGetAllTickersUseCase extends Mock implements GetAllTickersUseCase {}

void main() {
  late _MockGetAllTickersUseCase _mockGetAllTickersUseCase;
  late TickerCubit cubit;
  late TickerEntity tTicker;

  setUp(() {
    _mockGetAllTickersUseCase = _MockGetAllTickersUseCase();

    cubit = TickerCubit(
      getAllTickersUseCase: _mockGetAllTickersUseCase,
    );

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

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group(
    'TickerCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, TickerInitial());
      });

      blocTest<TickerCubit, TickerState>(
        'Order placed successfully',
        build: () {
          when(
            () => _mockGetAllTickersUseCase(),
          ).thenAnswer(
            (_) async => Right({tTicker.m: tTicker}),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getAllTickers();
        },
        expect: () => [
          TickerLoading(),
          TickerLoaded(ticker: {tTicker.m: tTicker}),
        ],
      );

      blocTest<TickerCubit, TickerState>(
        'Order placement failed',
        build: () {
          when(
            () => _mockGetAllTickersUseCase(),
          ).thenAnswer(
            (_) async => Left(ApiError(message: '')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getAllTickers();
        },
        expect: () => [
          TickerLoading(),
          TickerError(message: ''),
        ],
      );
    },
  );
}
