import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/trade_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/get_trades_usecase.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/common/utils/enums.dart';

class _TradeRepositoryMock extends Mock implements ITradeRepository {}

void main() {
  late GetTradesUseCase _usecase;
  late _TradeRepositoryMock _repository;
  late String mainAccount;
  late String asset;
  late EnumTradeTypes txnType;
  late DateTime time;
  late String status;
  late String amount;
  late String fee;
  late String address;
  late TradeEntity trade;

  setUp(() {
    _repository = _TradeRepositoryMock();
    _usecase = GetTradesUseCase(tradeRepository: _repository);
    mainAccount = '786653432';
    asset = "0";
    txnType = EnumTradeTypes.deposit;
    time = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'Filled';
    amount = "100.0";
    fee = "1.0";
    address = 'test';
    trade = TradeModel(
      mainAccount: mainAccount,
      txnType: txnType,
      asset: asset,
      amount: amount,
      fee: fee,
      status: status,
      time: time,
    );
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('GetTradesUsecase tests', () {
    test(
      'must get open trades successfully',
      () async {
        // arrange
        when(() => _repository.fetchTrades(any())).thenAnswer(
          (_) async => Right([trade]),
        );
        List<TradeEntity> tradesResult = [];
        // act
        final result = await _usecase(address: address);
        // assert

        result.fold(
          (_) => null,
          (trade) => tradesResult = [...trade],
        );

        expect(tradesResult.contains(trade), true);
        verify(() => _repository.fetchTrades(any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail to get open orders',
      () async {
        // arrange
        when(() => _repository.fetchTrades(any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(address: address);
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.fetchTrades(any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
