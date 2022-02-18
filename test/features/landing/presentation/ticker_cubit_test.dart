import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/models/ticker_model.dart';
import 'package:polkadex/features/landing/domain/entities/ticker_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/fetch_last_ticker_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:test/test.dart';

class _MockFetchLastTickerUseCaseUsecase extends Mock
    implements FetchLastTickerUseCase {}

void main() {
  late _MockFetchLastTickerUseCaseUsecase _mockFetchLastTickerUsecase;
  late TickerCubit cubit;
  late TickerEntity tTicker;

  setUp(() {
    _mockFetchLastTickerUsecase = _MockFetchLastTickerUseCaseUsecase();

    cubit = TickerCubit(
      fetchLastTickerUseCase: _mockFetchLastTickerUsecase,
    );

    tTicker = TickerModel(
      timestamp: DateTime.now(),
      high: '0',
      low: '0',
      last: '0',
      previousClose: '0',
      average: '0',
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
            () => _mockFetchLastTickerUsecase(
              leftTokenId: '0',
              rightTokenId: '1',
            ),
          ).thenAnswer(
            (_) async => Right(tTicker),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getLastTicker(
            leftTokenId: '0',
            rightTokenId: '1',
          );
        },
        expect: () => [
          TickerLoading(),
          TickerLoaded(ticker: tTicker),
        ],
      );

      blocTest<TickerCubit, TickerState>(
        'Order placement failed',
        build: () {
          when(
            () => _mockFetchLastTickerUsecase(
              leftTokenId: '0',
              rightTokenId: '1',
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: '')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getLastTicker(
            leftTokenId: '0',
            rightTokenId: '1',
          );
        },
        expect: () => [
          TickerLoading(),
          TickerError(message: ''),
        ],
      );
    },
  );
}
