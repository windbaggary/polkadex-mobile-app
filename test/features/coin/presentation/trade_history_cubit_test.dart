import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/account_trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_account_trades_updates_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_account_trades_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/coin/presentation/cubits/trade_history_cubit/trade_history_cubit.dart';
import 'package:test/test.dart';

class _MockGetAccountTradesUsecase extends Mock
    implements GetAccountTradesUseCase {}

class _MockGetAccountTradesUpdatesUseCase extends Mock
    implements GetAccountTradesUpdatesUseCase {}

void main() {
  late _MockGetAccountTradesUsecase _mockGetAccountTradesUsecase;
  late _MockGetAccountTradesUpdatesUseCase _mockGetAccountTradesUpdatesUseCase;
  late TradeHistoryCubit cubit;
  late String asset;
  late DateTime time;
  late String status;
  late double amount;
  late String fee;
  late String address;
  late AccountTradeEntity trade;

  setUp(() {
    _mockGetAccountTradesUsecase = _MockGetAccountTradesUsecase();
    _mockGetAccountTradesUpdatesUseCase = _MockGetAccountTradesUpdatesUseCase();

    cubit = TradeHistoryCubit(
        getTradesUseCase: _mockGetAccountTradesUsecase,
        getAccountTradesUpdatesUseCase: _mockGetAccountTradesUpdatesUseCase);

    asset = "0";
    time = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'OPEN';
    amount = 100.0;
    fee = "1.0";
    address = 'test';
    trade = AccountTradeModel(
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
            () => _mockGetAccountTradesUsecase(
              address: any(named: 'address'),
              from: any(named: 'from'),
              to: any(named: 'to'),
            ),
          ).thenAnswer(
            (_) async => Right([trade]),
          );
          when(
            () => _mockGetAccountTradesUpdatesUseCase(
              address: any(named: 'address'),
              onMsgReceived: any(named: 'onMsgReceived'),
              onMsgError: any(named: 'onMsgError'),
            ),
          ).thenAnswer(
            (_) async => Right(null),
          );

          return cubit;
        },
        act: (cubit) async {
          await cubit.getAccountTrades(
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
            () => _mockGetAccountTradesUsecase(
              address: any(named: 'address'),
              from: any(named: 'from'),
              to: any(named: 'to'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: 'error')),
          );
          when(
            () => _mockGetAccountTradesUpdatesUseCase(
              address: any(named: 'address'),
              onMsgReceived: any(named: 'onMsgReceived'),
              onMsgError: any(named: 'onMsgError'),
            ),
          ).thenAnswer(
            (_) async => Right(null),
          );

          return cubit;
        },
        act: (cubit) async {
          await cubit.getAccountTrades(
            '0',
            address,
          );
        },
        expect: () => [
          TradeHistoryLoading(),
          TradeHistoryError(message: 'error'),
        ],
      );
    },
  );
}
