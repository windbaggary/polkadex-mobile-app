import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/common/trades/domain/usecases/place_order_usecase.dart';

class _OrderRepositoryMock extends Mock implements ITradeRepository {}

void main() {
  late PlaceOrderUseCase _usecase;
  late _OrderRepositoryMock _repository;
  late int nonce;
  late String baseAsset;
  late String quoteAsset;
  late EnumTradeTypes event;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late String amount;
  late String price;
  late OrderEntity order;
  late String address;

  setUp(() {
    _repository = _OrderRepositoryMock();
    _usecase = PlaceOrderUseCase(tradeRepository: _repository);
    nonce = 0;
    baseAsset = "0";
    quoteAsset = "1";
    event = EnumTradeTypes.bid;
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    amount = "100.0";
    price = "50.0";
    address = 'test';
    order = order = OrderModel(
        tradeId: '0',
        amount: amount,
        price: price,
        event: event,
        orderSide: orderSide,
        orderType: orderType,
        timestamp: DateTime.now(),
        baseAsset: baseAsset,
        quoteAsset: quoteAsset,
        status: 'Open',
        market: '$baseAsset/$quoteAsset');
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('PlaceOrderUsecase tests', () {
    test(
      'must place an orders successfully',
      () async {
        // arrange
        when(() => _repository.placeOrder(
            any(), any(), any(), any(), any(), any(), any(), any())).thenAnswer(
          (_) async => Right(order),
        );
        OrderEntity? orderResult;
        // act
        final result = await _usecase(
          nonce: nonce,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orderType: orderType,
          orderSide: orderSide,
          price: price,
          amount: amount,
          address: address,
        );
        // assert

        result.fold(
          (_) => null,
          (order) => orderResult = order,
        );

        expect(orderResult, order);
        verify(() => _repository.placeOrder(
            any(), any(), any(), any(), any(), any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail to place an orders',
      () async {
        // arrange
        when(() => _repository.placeOrder(
            any(), any(), any(), any(), any(), any(), any(), any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(
          nonce: nonce,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orderType: orderType,
          orderSide: orderSide,
          price: price,
          amount: amount,
          address: address,
        );
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.placeOrder(
            any(), any(), any(), any(), any(), any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
