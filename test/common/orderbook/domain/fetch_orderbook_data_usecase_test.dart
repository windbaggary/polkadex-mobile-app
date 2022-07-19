import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orderbook/data/models/orderbook_model.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';
import 'package:polkadex/common/orderbook/domain/repositories/iorderbook_repository.dart';
import 'package:polkadex/common/orderbook/domain/usecases/get_orderbook_data_usecase.dart';

class _OrderbookRepositoryMock extends Mock implements IOrderbookRepository {}

void main() {
  late GetOrderbookDataUseCase _usecase;
  late _OrderbookRepositoryMock _repository;
  late OrderbookEntity tOrderbook;

  setUp(() {
    _repository = _OrderbookRepositoryMock();
    _usecase = GetOrderbookDataUseCase(orderbookRepository: _repository);
    tOrderbook = OrderbookModel(
      ask: [],
      bid: [],
    );
  });

  group('FetchOrderbookDataUseCase tests', () {
    test(
      "must fetch order book data successfully",
      () async {
        // arrange
        when(() => _repository.getOrderbookData(
              any(),
              any(),
            )).thenAnswer(
          (_) async => Right(tOrderbook),
        );
        OrderbookEntity? orderbookResult;
        // act
        final result = await _usecase(
          leftTokenId: '0',
          rightTokenId: '0',
        );
        // assert

        result.fold(
          (_) => null,
          (orderbook) => orderbookResult = orderbook,
        );

        expect(orderbookResult, tOrderbook);
        verify(() => _repository.getOrderbookData(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to test a deposit",
      () async {
        // arrange
        when(() => _repository.getOrderbookData(any(), any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(
          leftTokenId: '0',
          rightTokenId: '0',
        );
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.getOrderbookData(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
