import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_trades_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/coin/presentation/cubits/trade_history_cubit/trade_history_cubit.dart';
import 'package:test/test.dart';

class _MockGetTradesUsecase extends Mock implements GetTradesUseCase {}

void main() {
  late _MockGetTradesUsecase _mockGetTradesUsecase;
  late TradeHistoryCubit cubit;
  late String mainAccount;
  late String asset;
  late DateTime time;
  late String status;
  late String amount;
  late String fee;
  late String address;
  late TradeEntity trade;

  setUp(() {
    _mockGetTradesUsecase = _MockGetTradesUsecase();

    cubit = TradeHistoryCubit(
      getTradesUseCase: _mockGetTradesUsecase,
    );

    mainAccount = '786653432';
    asset = "0";
    time = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'PartiallyFilled';
    amount = "100.0";
    fee = "1.0";
    address = 'test';
    trade = TradeModel(
      mainAccount: mainAccount,
      txnType: EnumTradeTypes.deposit,
      asset: asset,
      amount: amount,
      fee: fee,
      status: status,
      time: time,
    );
  });

  group(
    'TradeHistoryCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, TradeHistoryInitial());
      });

      blocTest<TradeHistoryCubit, TradeHistoryState>(
        'Trades fetched successfully',
        build: () {
          when(
            () => _mockGetTradesUsecase(address: any(named: 'address')),
          ).thenAnswer(
            (_) async => Right([trade]),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getTrades(
            '0',
            address,
          );
        },
        expect: () => [
          TradeHistoryLoading(),
          TradeHistoryLoaded(trades: [trade]),
        ],
      );

      blocTest<TradeHistoryCubit, TradeHistoryState>(
        'Trades fetch fail',
        build: () {
          when(
            () => _mockGetTradesUsecase(address: any(named: 'address')),
          ).thenAnswer(
            (_) async => Left(ApiError(message: 'error')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getTrades(
            '0',
            address,
          );
        },
        expect: () => [
          TradeHistoryLoading(),
          TradeHistoryError(),
        ],
      );
    },
  );
}
