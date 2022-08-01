import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/trades/data/models/order_model.dart';
import 'package:polkadex/common/trades/domain/entities/order_entity.dart';
import 'package:polkadex/common/trades/domain/usecases/place_order_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:test/test.dart';

class _MockPlaceOrderUsecase extends Mock implements PlaceOrderUseCase {}

void main() {
  late _MockPlaceOrderUsecase _mockPlaceOrderUsecase;
  late PlaceOrderCubit cubit;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late String qty;
  late String price;
  late OrderEntity order;
  late String mainAddress;
  late String proxyAddress;

  setUp(() {
    _mockPlaceOrderUsecase = _MockPlaceOrderUsecase();

    cubit = PlaceOrderCubit(
      placeOrderUseCase: _mockPlaceOrderUsecase,
    );

    baseAsset = "0";
    quoteAsset = "1";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    qty = '100.0';
    price = '50.0';
    mainAddress = 'test';
    proxyAddress = 'tset';
    order = OrderModel(
      mainAccount: mainAddress,
      tradeId: '0',
      clientId: '',
      qty: qty,
      price: price,
      orderSide: orderSide,
      orderType: orderType,
      time: DateTime.now(),
      baseAsset: baseAsset,
      quoteAsset: quoteAsset,
      status: 'Open',
    );
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group(
    'PlaceOrderCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, PlaceOrderInitial());
      });

      blocTest<PlaceOrderCubit, PlaceOrderState>(
        'Order placed successfully',
        build: () {
          when(
            () => _mockPlaceOrderUsecase(
              mainAddress: any(named: 'mainAddress'),
              proxyAddress: any(named: 'proxyAddress'),
              baseAsset: any(named: 'baseAsset'),
              quoteAsset: any(named: 'quoteAsset'),
              orderType: any(named: 'orderType'),
              orderSide: any(named: 'orderSide'),
              price: any(named: 'price'),
              amount: any(named: 'amount'),
            ),
          ).thenAnswer(
            (_) async => Right(order),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.placeOrder(
            mainAddress: mainAddress,
            proxyAddress: proxyAddress,
            baseAsset: baseAsset,
            quoteAsset: quoteAsset,
            orderType: orderType,
            orderSide: orderSide,
            price: price,
            amount: qty,
          );
        },
        expect: () => [
          isA<PlaceOrderLoading>(),
          isA<PlaceOrderAccepted>(),
        ],
      );

      blocTest<PlaceOrderCubit, PlaceOrderState>(
        'Order placement failed',
        build: () {
          when(
            () => _mockPlaceOrderUsecase(
              mainAddress: any(named: 'mainAddress'),
              proxyAddress: any(named: 'proxyAddress'),
              baseAsset: any(named: 'baseAsset'),
              quoteAsset: any(named: 'quoteAsset'),
              orderType: any(named: 'orderType'),
              orderSide: any(named: 'orderSide'),
              price: any(named: 'price'),
              amount: any(named: 'amount'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: '')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.placeOrder(
            mainAddress: mainAddress,
            proxyAddress: proxyAddress,
            baseAsset: baseAsset,
            quoteAsset: quoteAsset,
            orderType: orderType,
            orderSide: orderSide,
            price: price,
            amount: qty,
          );
        },
        expect: () => [
          isA<PlaceOrderLoading>(),
          isA<PlaceOrderNotAccepted>(),
        ],
      );
    },
  );
}
