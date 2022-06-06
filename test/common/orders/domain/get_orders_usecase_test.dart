import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class _OrderRepositoryMock extends Mock implements ITradeRepository {}

void main() {
  late GetOrdersUseCase _usecase;
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
  late OrderModel order;

  setUp(() {
    _repository = _OrderRepositoryMock();
    _usecase = GetOrdersUseCase(tradeRepository: _repository);
    orderId = '786653432';
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    timestamp = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'Filled';
    amount = "100.0";
    price = "50.0";
    address = 'test';
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

  group('GetOrdersUsecase tests', () {
    test(
      'must get open orders successfully',
      () async {
        // arrange
        when(() => _repository.fetchOrders(any())).thenAnswer(
          (_) async => Right([order]),
        );
        List<OrderEntity> ordersResult = [];
        // act
        final result = await _usecase(address: address);
        // assert

        result.fold(
          (_) => null,
          (order) => ordersResult = [...order],
        );

        expect(ordersResult.contains(order), true);
        verify(() => _repository.fetchOrders(any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail to get open orders',
      () async {
        // arrange
        when(() => _repository.fetchOrders(any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(address: address);
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.fetchOrders(any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
