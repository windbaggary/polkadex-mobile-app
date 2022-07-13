import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/account_trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/account_trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_account_trades_usecase.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/common/utils/enums.dart';

class _TradeRepositoryMock extends Mock implements ITradeRepository {}

void main() {
  late GetAccountTradesUseCase _usecase;
  late _TradeRepositoryMock _repository;
  late String mainAccount;
  late String asset;
  late EnumTradeTypes txnType;
  late DateTime time;
  late String status;
  late String amount;
  late String fee;
  late String address;
  late AccountTradeEntity trade;
  late DateTime tFrom;
  late DateTime tTo;

  setUp(() {
    _repository = _TradeRepositoryMock();
    _usecase = GetAccountTradesUseCase(tradeRepository: _repository);
    mainAccount = '786653432';
    asset = "0";
    txnType = EnumTradeTypes.deposit;
    time = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'Filled';
    amount = "100.0";
    fee = "1.0";
    address = 'test';
    trade = AccountTradeModel(
      mainAccount: mainAccount,
      txnType: txnType,
      asset: asset,
      amount: amount,
      fee: fee,
      status: status,
      time: time,
    );
    tFrom = DateTime.fromMicrosecondsSinceEpoch(0);
    tTo = DateTime.now();
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('GetAccountTradesUsecase tests', () {
    test(
      'must get account trades successfully',
      () async {
        // arrange
        when(() => _repository.fetchAccountTrades(any(), any(), any()))
            .thenAnswer(
          (_) async => Right([trade]),
        );
        List<AccountTradeEntity> tradesResult = [];
        // act
        final result = await _usecase(address: address, from: tFrom, to: tTo);
        // assert

        result.fold(
          (_) => null,
          (trade) => tradesResult = [...trade],
        );

        expect(tradesResult.contains(trade), true);
        verify(() => _repository.fetchAccountTrades(any(), any(), any()))
            .called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail to get account trades',
      () async {
        // arrange
        when(() => _repository.fetchAccountTrades(any(), any(), any()))
            .thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(address: address, from: tFrom, to: tTo);
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.fetchAccountTrades(any(), any(), any()))
            .called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
