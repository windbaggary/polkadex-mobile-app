import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/usecases/cancel_order_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_updates_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_usecase.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/presentation/cubits/order_history_cubit/order_history_cubit.dart';
import 'package:test/test.dart';

class _MockGetOrdersUsecase extends Mock implements GetOrdersUseCase {}

class _MockGetOrdersUpdatesUseCase extends Mock
    implements GetOrdersUpdatesUseCase {}

class _MockCancelOrderUsecase extends Mock implements CancelOrderUseCase {}

void main() {
  late _MockGetOrdersUsecase _mockGetOrdersUsecase;
  late _MockGetOrdersUpdatesUseCase _mockGetOrdersUpdatesUseCase;
  late _MockCancelOrderUsecase _mockCancelOrderUsecase;
  late OrderHistoryCubit cubit;
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

  setUp(() {
    _mockGetOrdersUsecase = _MockGetOrdersUsecase();
    _mockGetOrdersUpdatesUseCase = _MockGetOrdersUpdatesUseCase();
    _mockCancelOrderUsecase = _MockCancelOrderUsecase();

    cubit = OrderHistoryCubit(
      getOrdersUseCase: _mockGetOrdersUsecase,
      getOrdersUpdatesUseCase: _mockGetOrdersUpdatesUseCase,
      cancelOrderUseCase: _mockCancelOrderUsecase,
    );

    orderId = '786653432';
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    time = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'PartiallyFilled';
    qty = "100.0";
    price = "50.0";
    address = 'test';
    order = OrderModel(
      mainAccount: address,
      tradeId: orderId,
      qty: qty,
      price: price,
      orderSide: orderSide,
      orderType: orderType,
      time: time,
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      status: status,
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
            () => _mockGetOrdersUsecase(
              address: any(named: 'address'),
              from: any(named: 'from'),
              to: any(named: 'to'),
            ),
          ).thenAnswer(
            (_) async => Right([order]),
          );
          when(
            () => _mockGetOrdersUpdatesUseCase(
              address: any(named: 'address'),
              onMsgReceived: any(named: 'onMsgReceived'),
              onMsgError: any(named: 'onMsgError'),
            ),
          ).thenAnswer(
            (_) async => Right(null),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getOrders(
            '0',
            address,
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
            () => _mockGetOrdersUsecase(
              address: any(named: 'address'),
              from: any(named: 'from'),
              to: any(named: 'to'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: 'error')),
          );
          when(
            () => _mockGetOrdersUpdatesUseCase(
              address: any(named: 'address'),
              onMsgReceived: any(named: 'onMsgReceived'),
              onMsgError: any(named: 'onMsgError'),
            ),
          ).thenAnswer(
            (_) async => Right(null),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getOrders(
            '0',
            address,
            false,
          );
        },
        expect: () => [
          OrderHistoryLoading(),
          OrderHistoryError(message: ''),
        ],
      );
    },
  );
}
