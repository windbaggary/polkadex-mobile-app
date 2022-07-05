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
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late String amount;
  late String price;
  late OrderEntity order;
  late String mainAddress;
  late String proxyAddress;

  setUp(() {
    _repository = _OrderRepositoryMock();
    _usecase = PlaceOrderUseCase(tradeRepository: _repository);
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    amount = "100.0";
    price = "50.0";
    mainAddress = 'test';
    proxyAddress = 'tset';
    order = order = OrderModel(
        tradeId: '0',
        amount: amount,
        price: price,
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
          mainAddress: mainAddress,
          proxyAddress: proxyAddress,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orderType: orderType,
          orderSide: orderSide,
          price: price,
          amount: amount,
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
          mainAddress: mainAddress,
          proxyAddress: proxyAddress,
          baseAsset: baseAsset,
          quoteAsset: quoteAsset,
          orderType: orderType,
          orderSide: orderSide,
          price: price,
          amount: amount,
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
