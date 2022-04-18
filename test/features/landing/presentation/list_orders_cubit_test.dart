import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orders/data/models/fee_model.dart';
import 'package:polkadex/common/orders/data/models/order_model.dart';
import 'package:polkadex/common/orders/domain/entities/fee_entity.dart';
import 'package:polkadex/common/orders/domain/usecases/get_open_orders.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/presentation/cubits/list_orders_cubit/list_orders_cubit.dart';
import 'package:test/test.dart';

class _MockGetOpenOrdersUsecase extends Mock implements GetOpenOrdersUseCase {}

void main() {
  late _MockGetOpenOrdersUsecase _mockGetOpenOrdersUsecase;
  late ListOrdersCubit cubit;
  late String orderId;
  late String mainAcc;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late DateTime timestamp;
  late String status;
  late String filledQty;
  late String currency;
  late String cost;
  late String amount;
  late String price;
  late String address;
  late String signature;
  late FeeEntity fee;
  late OrderModel order;

  setUp(() {
    _mockGetOpenOrdersUsecase = _MockGetOpenOrdersUsecase();

    cubit = ListOrdersCubit(
      getOpenOrdersUseCase: _mockGetOpenOrdersUsecase,
    );

    orderId = '786653432';
    mainAcc = '5HDnQBPKDNUXL9qvWVzP8j3pgoh6Sa';
    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    timestamp = DateTime.fromMillisecondsSinceEpoch(1644853305519);
    status = 'open';
    filledQty = '2.5';
    currency = '0';
    cost = '0';
    amount = "100.0";
    price = "50.0";
    address = 'test';
    signature = 'test';
    fee = FeeModel(currency: currency, cost: cost);
    order = OrderModel(
      orderId: orderId,
      mainAcc: mainAcc,
      amount: amount,
      price: price,
      orderSide: orderSide,
      orderType: orderType,
      timestamp: timestamp,
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      status: status,
      filledQty: filledQty,
      fee: fee,
      trades: [],
    );
  });

  group(
    'ListOrdersCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, ListOrdersInitial());
      });

      blocTest<ListOrdersCubit, ListOrdersState>(
        'Open orders fetched successfully',
        build: () {
          when(
            () => _mockGetOpenOrdersUsecase(
              address: any(named: 'address'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Right([order]),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getOpenOrders(
            address,
            signature,
          );
        },
        expect: () => [
          ListOrdersLoading(),
          ListOrdersLoaded(openOrders: [order], orderIdsLoading: []),
        ],
      );

      blocTest<ListOrdersCubit, ListOrdersState>(
        'Open orders fetch failed',
        build: () {
          when(
            () => _mockGetOpenOrdersUsecase(
              address: any(named: 'address'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: 'error')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getOpenOrders(
            address,
            signature,
          );
        },
        expect: () => [
          ListOrdersLoading(),
          ListOrdersError(),
        ],
      );
    },
  );
}
