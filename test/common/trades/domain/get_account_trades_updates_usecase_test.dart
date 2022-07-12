import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/trades/domain/usecases/get_account_trades_updates_usecase.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/common/utils/enums.dart';

class _TradeRepositoryMock extends Mock implements ITradeRepository {}

void main() {
  late GetAccountTradesUpdatesUseCase _usecase;
  late _TradeRepositoryMock _repository;
  late String address;

  setUp(() {
    _repository = _TradeRepositoryMock();
    _usecase = GetAccountTradesUpdatesUseCase(tradeRepository: _repository);
    address = 'test';
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('GetAccountTradesUsecase tests', () {
    test(
      'must get account trades updates',
      () async {
        // arrange
        when(() => _repository.fetchAccountTradesUpdates(any(), any(), any()))
            .thenAnswer(
          (_) async => Right(null),
        );
        // act
        await _usecase(
          address: address,
          onMsgReceived: (_) {},
          onMsgError: (_) {},
        );
        // assert

        verify(() => _repository.fetchAccountTradesUpdates(
              any(),
              any(),
              any(),
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
