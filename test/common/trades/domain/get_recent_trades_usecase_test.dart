import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/recent_trade_model.dart';
import 'package:polkadex/common/trades/domain/entities/recent_trade_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/common/trades/domain/usecases/get_recent_trades_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';

class _TradeRepositoryMock extends Mock implements ITradeRepository {}

void main() {
  late GetRecentTradesUseCase _usecase;
  late _TradeRepositoryMock _repository;
  late String m;
  late double qty;
  late double price;
  late DateTime time;
  late RecentTradeEntity trade;

  setUp(() {
    _repository = _TradeRepositoryMock();
    _usecase = GetRecentTradesUseCase(tradeRepository: _repository);
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

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('GetRecentTradesUsecase tests', () {
    test(
      'must get open recent trades successfully',
      () async {
        // arrange
        when(() => _repository.fetchRecentTrades(any())).thenAnswer(
          (_) async => Right([trade]),
        );
        List<RecentTradeEntity> tradesResult = [];
        // act
        final result = await _usecase(market: m);
        // assert

        result.fold(
          (_) => null,
          (trade) => tradesResult = [...trade],
        );

        expect(tradesResult.contains(trade), true);
        verify(() => _repository.fetchRecentTrades(any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail to get recent trades',
      () async {
        // arrange
        when(() => _repository.fetchRecentTrades(any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(market: m);
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.fetchRecentTrades(any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
