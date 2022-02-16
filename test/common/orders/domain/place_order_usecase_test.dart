import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/data/models/fee_model.dart';
import 'package:polkadex/common/orders/data/models/order_model.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/orders/domain/repositories/iorder_repository.dart';
import 'package:polkadex/common/orders/domain/usecases/place_order_usecase.dart';

class _OrderRepositoryMock extends Mock implements IOrderRepository {}

void main() {
  late PlaceOrderUseCase _usecase;
  late _OrderRepositoryMock _repository;
  late int nonce;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late String amount;
  late String price;
  late OrderEntity order;
  late String address;
  late String signature;

  setUp(() {
    _repository = _OrderRepositoryMock();
    _usecase = PlaceOrderUseCase(orderRepository: _repository);
    nonce = 0;
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    amount = "100.0";
    price = "50.0";
    address = 'test';
    signature = 'test';
    order = order = OrderModel(
      orderId: '0',
      mainAcc: address,
      amount: amount,
      price: price,
      orderSide: orderSide,
      orderType: orderType,
      timestamp: DateTime.now(),
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      status: 'Open',
      filledQty: '0.0',
      fee: FeeModel(currency: baseAsset.toString(), cost: '0'),
      trades: [],
    );
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
                any(), any(), any(), any(), any(), any(), any(), any(), any()))
            .thenAnswer(
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
          signature: signature,
        );
        // assert

        result.fold(
          (_) => null,
          (order) => orderResult = order,
        );

        expect(orderResult, order);
        verify(() => _repository.placeOrder(
                any(), any(), any(), any(), any(), any(), any(), any(), any()))
            .called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail to place an orders',
      () async {
        // arrange
        when(() => _repository.placeOrder(
                any(), any(), any(), any(), any(), any(), any(), any(), any()))
            .thenAnswer(
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
          signature: signature,
        );
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.placeOrder(
                any(), any(), any(), any(), any(), any(), any(), any(), any()))
            .called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
