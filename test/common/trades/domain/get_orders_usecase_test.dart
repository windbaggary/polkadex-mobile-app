import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';

class _TradeRepositoryMock extends Mock implements ITradeRepository {}

void main() {
  late GetOrdersUseCase _usecase;
  late _TradeRepositoryMock _repository;
  late String mainAccount;
  late String orderId;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late DateTime time;
  late String status;
  late String qty;
  late String price;
  late String address;
  late OrderModel order;
  late DateTime tFrom;
  late DateTime tTo;

  setUp(() {
    _repository = _TradeRepositoryMock();
    _usecase = GetOrdersUseCase(tradeRepository: _repository);
    mainAccount = 'asdfghj';
    orderId = '786653432';
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    time = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'Filled';
    qty = "100.0";
    price = "50.0";
    address = 'test';
    order = OrderModel(
      mainAccount: mainAccount,
      tradeId: orderId,
      clientId: '',
      qty: qty,
      price: price,
      orderSide: orderSide,
      orderType: orderType,
      time: time,
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      status: status,
    );
    tFrom = DateTime.fromMicrosecondsSinceEpoch(0);
    tTo = DateTime.now();
  });

  setUpAll(() {
    registerFallbackValue(EnumOrderTypes.market);
    registerFallbackValue(EnumBuySell.buy);
  });

  group('GetOrdersUsecase tests', () {
    test(
      'must get open orders successfully',
      () async {
        // arrange
        when(() => _repository.fetchOrders(any(), any(), any())).thenAnswer(
          (_) async => Right([order]),
        );
        List<OrderEntity> ordersResult = [];
        // act
        final result = await _usecase(address: address, from: tFrom, to: tTo);
        // assert

        result.fold(
          (_) => null,
          (order) => ordersResult = [...order],
        );

        expect(ordersResult.contains(order), true);
        verify(() => _repository.fetchOrders(any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail to get open orders',
      () async {
        // arrange
        when(() => _repository.fetchOrders(any(), any(), any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(address: address, from: tFrom, to: tTo);
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.fetchOrders(any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
