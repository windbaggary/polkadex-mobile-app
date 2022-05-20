import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orders/domain/usecases/get_open_orders.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/orders/data/models/order_model.dart';
import 'package:polkadex/common/orders/domain/entities/order_entity.dart';
import 'package:polkadex/common/orders/domain/repositories/iorder_repository.dart';

class _OrderRepositoryMock extends Mock implements IOrderRepository {}

void main() {
  late GetOpenOrdersUseCase _usecase;
  late _OrderRepositoryMock _repository;
  late String orderId;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late DateTime timestamp;
  late String status;
  late String amount;
  late String price;
  late String address;
  late String signature;
  late OrderModel order;

  setUp(() {
    _repository = _OrderRepositoryMock();
    _usecase = GetOpenOrdersUseCase(orderRepository: _repository);
    orderId = '786653432';
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    timestamp = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'PartiallyFilled';
    amount = "100.0";
    price = "50.0";
    address = 'test';
    signature = 'test';
    order = OrderModel(
      orderId: orderId,
      amount: amount,
      price: price,
      orderSide: orderSide,
      orderType: orderType,
      timestamp: timestamp,
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      status: status,
    );
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group('GetOpenOrdersUsecase tests', () {
    test(
      'must get open orders successfully',
      () async {
        // arrange
        when(() => _repository.fetchOpenOrders(any(), any())).thenAnswer(
          (_) async => Right([order]),
        );
        List<OrderEntity> ordersResult = [];
        // act
        final result = await _usecase(
          address: address,
          signature: signature,
        );
        // assert

        result.fold(
          (_) => null,
          (order) => ordersResult = [...order],
        );

        expect(ordersResult.contains(order), true);
        verify(() => _repository.fetchOpenOrders(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail to get open orders',
      () async {
        // arrange
        when(() => _repository.fetchOpenOrders(
              any(),
              any(),
            )).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(
          address: address,
          signature: signature,
        );
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.fetchOpenOrders(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
