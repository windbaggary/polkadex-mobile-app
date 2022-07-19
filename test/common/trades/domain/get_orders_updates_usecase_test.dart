import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_updates_usecase.dart';

class _TradeRepositoryMock extends Mock implements ITradeRepository {}

void main() {
  late GetOrdersUpdatesUseCase _usecase;
  late _TradeRepositoryMock _repository;
  late String address;

  setUp(() {
    _repository = _TradeRepositoryMock();
    _usecase = GetOrdersUpdatesUseCase(tradeRepository: _repository);
    address = 'test';
  });

  group('GetOrdersUpdatesUseCase tests', () {
    test(
      'must get orders updates',
      () async {
        // arrange
        when(() => _repository.fetchOrdersUpdates(any(), any(), any()))
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

        verify(() => _repository.fetchOrdersUpdates(
              any(),
              any(),
              any(),
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
