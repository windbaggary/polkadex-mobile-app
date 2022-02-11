import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orderbook/domain/repositories/iorderbook_repository.dart';
import 'package:polkadex/common/orderbook/domain/usecases/fetch_orderbook_live_data_usecase.dart';

class _OrderbookRepositoryMock extends Mock implements IOrderbookRepository {}

void main() {
  late FetchOrderbookLiveDataUseCase _usecase;
  late _OrderbookRepositoryMock _repository;

  setUp(() {
    _repository = _OrderbookRepositoryMock();
    _usecase = FetchOrderbookLiveDataUseCase(orderbookRepository: _repository);
  });

  group('FetchOrderbookLiveDataUseCase tests', () {
    test(
      "must fetch order book live data",
      () async {
        // arrange
        when(() => _repository.getOrderbookLiveData(
              any(),
              any(),
              any(),
              any(),
            )).thenAnswer(
          (_) async => Right(null),
        );
        // act
        final result = await _usecase(
          leftTokenId: '0',
          rightTokenId: '0',
          onMsgReceived: (_) {},
          onMsgError: (_) {},
        );

        expect(result.isRight(), true);
        verify(() => _repository.getOrderbookLiveData(
              any(),
              any(),
              any(),
              any(),
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to fetch order book live data",
      () async {
        // arrange
        when(() => _repository.getOrderbookLiveData(
              any(),
              any(),
              any(),
              any(),
            )).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        ApiError? orderbookResult;
        // act
        final result = await _usecase(
          leftTokenId: '0',
          rightTokenId: '0',
          onMsgReceived: (_) {},
          onMsgError: (_) {},
        );
        // assert
        result.fold(
          (error) => orderbookResult = error,
          (_) => null,
        );

        expect(orderbookResult != null, true);
        verify(() => _repository.getOrderbookLiveData(
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
