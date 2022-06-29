import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/usecases/cancel_order_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/presentation/cubits/order_history_cubit/order_history_cubit.dart';
import 'package:test/test.dart';

class _MockGetOrdersUsecase extends Mock implements GetOrdersUseCase {}

class _MockCancelOrderUsecase extends Mock implements CancelOrderUseCase {}

void main() {
  late _MockGetOrdersUsecase _mockGetOrdersUsecase;
  late _MockCancelOrderUsecase _mockCancelOrderUsecase;
  late OrderHistoryCubit cubit;
  late String orderId;
  late String baseAsset;
  late String quoteAsset;
  late EnumTradeTypes event;
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
    _mockGetOrdersUsecase = _MockGetOrdersUsecase();
    _mockCancelOrderUsecase = _MockCancelOrderUsecase();

    cubit = OrderHistoryCubit(
      getOrdersUseCase: _mockGetOrdersUsecase,
      cancelOrderUseCase: _mockCancelOrderUsecase,
    );

    orderId = '786653432';
    baseAsset = "0";
    quoteAsset = "1";
    event = EnumTradeTypes.bid;
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    timestamp = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'PartiallyFilled';
    amount = "100.0";
    price = "50.0";
    address = 'test';
    signature = 'test';
    order = OrderModel(
      tradeId: orderId,
      amount: amount,
      price: price,
      event: event,
      orderSide: orderSide,
      orderType: orderType,
      timestamp: timestamp,
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      status: status,
      market: '$baseAsset/$quoteAsset',
    );
  });

  group(
    'ListOrdersCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, OrderHistoryInitial());
      });

      blocTest<OrderHistoryCubit, OrderHistoryState>(
        'Orders fetched successfully',
        build: () {
          when(
            () => _mockGetOrdersUsecase(address: any(named: 'address')),
          ).thenAnswer(
            (_) async => Right([order]),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getOrders(
            '0',
            address,
            signature,
            false,
          );
        },
        expect: () => [
          OrderHistoryLoading(),
          OrderHistoryLoaded(
            orders: [order],
            orderIdsLoading: [],
          ),
        ],
      );

      blocTest<OrderHistoryCubit, OrderHistoryState>(
        'Orders fetch fail',
        build: () {
          when(
            () => _mockGetOrdersUsecase(address: any(named: 'address')),
          ).thenAnswer(
            (_) async => Left(ApiError(message: 'error')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getOrders(
            '0',
            address,
            signature,
            false,
          );
        },
        expect: () => [
          OrderHistoryLoading(),
          OrderHistoryError(),
        ],
      );
    },
  );
}
