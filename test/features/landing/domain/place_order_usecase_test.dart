import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/models/order_model.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/iorder_repository.dart';
import 'package:polkadex/features/landing/domain/usecases/place_order_usecase.dart';

class _OrderRepositoryMock extends Mock implements IOrderRepository {}

void main() {
  late PlaceOrderUseCase _usecase;
  late _OrderRepositoryMock _repository;
  late int nonce;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late double quantity;
  late double price;
  late OrderEntity order;

  setUp(() {
    _repository = _OrderRepositoryMock();
    _usecase = PlaceOrderUseCase(orderRepository: _repository);
    nonce = 0;
    baseAsset = "BTC";
    quoteAsset = "USD";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    quantity = 100.0;
    price = 50.0;
    order = OrderModel(
      uuid: 'abcd',
      type: orderSide,
      amount: quantity.toString(),
      price: price.toString(),
      dateTime: DateTime.now(),
      amountCoin: baseAsset,
      priceCoin: quoteAsset,
      orderType: orderType,
      tokenPairName: '$baseAsset/$quoteAsset',
    );
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('PlaceOrderUsecase tests', () {
    test(
      'must place an order successfully',
      () async {
        // arrange
        when(() => _repository.placeOrder(
            any(), any(), any(), any(), any(), any(), any())).thenAnswer(
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
          quantity: quantity,
        );
        // assert

        result.fold(
          (_) => null,
          (order) => orderResult = order,
        );

        expect(orderResult, order);
        verify(() => _repository.placeOrder(
            any(), any(), any(), any(), any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail to place an order',
      () async {
        // arrange
        when(() => _repository.placeOrder(
            any(), any(), any(), any(), any(), any(), any())).thenAnswer(
          (_) async => Left(ApiError()),
        );
        // act
        final result = await _usecase(
          nonce: nonce,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orderType: orderType,
          orderSide: orderSide,
          price: price,
          quantity: quantity,
        );
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.placeOrder(
            any(), any(), any(), any(), any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
