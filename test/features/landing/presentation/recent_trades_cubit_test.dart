import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/recent_trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_recent_trades_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/recent_trades_cubit/recent_trades_cubit.dart';
import 'package:test/test.dart';

class _MockGetRecentTradesUseCase extends Mock
    implements GetRecentTradesUseCase {}

void main() {
  late _MockGetRecentTradesUseCase _mockGetRecentTradesUseCase;
  late String m;
  late double qty;
  late double price;
  late DateTime time;
  late RecentTradeEntity trade;
  late RecentTradesCubit cubit;
  setUp(() {
    _mockGetRecentTradesUseCase = _MockGetRecentTradesUseCase();

    cubit = RecentTradesCubit(
      getRecentTradesUseCase: _mockGetRecentTradesUseCase,
    );

    m = "PDEX-1";
    qty = 1.0;
    price = 2.0;
    time = DateTime.now();
    trade = RecentTradeModel(
      m: m,
      qty: qty,
      price: price,
      time: time,
    );
  });

  group(
    'RecentTradesCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, RecentTradesInitial());
      });

      blocTest<RecentTradesCubit, RecentTradesState>(
        'Recent trades data fetched successfully',
        build: () {
          when(
            () => _mockGetRecentTradesUseCase(market: m),
          ).thenAnswer(
            (_) async => Right([trade]),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getRecentTrades(m);
        },
        expect: () => [
          RecentTradesLoading(),
          RecentTradesLoaded(trades: [trade])
        ],
      );

      blocTest<RecentTradesCubit, RecentTradesState>(
        'Market fetch successfull and Asset data fetch fail',
        build: () {
          when(
            () => _mockGetRecentTradesUseCase(market: m),
          ).thenAnswer(
            (_) async => Left(ApiError(message: '')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getRecentTrades(m);
        },
        expect: () => [
          RecentTradesLoading(),
          RecentTradesError(),
        ],
      );
    },
  );
}
