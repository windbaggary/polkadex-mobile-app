import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/orderbook/domain/repositories/iorderbook_repository.dart';
import 'package:polkadex/common/orderbook/domain/usecases/get_orderbook_updates_usecase.dart';

class _OrderbookRepositoryMock extends Mock implements IOrderbookRepository {}

void main() {
  late GetOrderbookUpdatesUseCase _usecase;
  late _OrderbookRepositoryMock _repository;

  setUp(() {
    _repository = _OrderbookRepositoryMock();
    _usecase = GetOrderbookUpdatesUseCase(orderbookRepository: _repository);
  });

  group('FetchOrderbookLiveDataUseCase tests', () {
    test(
      "must fetch order book live data",
      () async {
        // arrange
        when(() => _repository.getOrderbookUpdates(
              any(),
              any(),
              any(),
              any(),
            )).thenAnswer(
          (_) async => Right(null),
        );
        // act
        await _usecase(
          leftTokenId: '0',
          rightTokenId: '0',
          onMsgReceived: (_) {},
          onMsgError: (_) {},
        );

        verify(() => _repository.getOrderbookUpdates(
              any(),
              any(),
              any(),
              any(),
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
