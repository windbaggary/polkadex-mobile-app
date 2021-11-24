import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/domain/usecases/place_order_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/order_cubit.dart';
import 'package:test/test.dart';

class _MockPlaceOrderUsecase extends Mock implements PlaceOrderUseCase {}

void main() {
  late _MockPlaceOrderUsecase _mockPlaceOrderUsecase;
  late OrderCubit cubit;
  late int nonce;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late double quantity;
  late double price;

  setUp(() {
    _mockPlaceOrderUsecase = _MockPlaceOrderUsecase();

    cubit = OrderCubit(
      placeOrderUseCase: _mockPlaceOrderUsecase,
    );

    nonce = 0;
    baseAsset = "BTC";
    quoteAsset = "USD";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    quantity = 100.0;
    price = 50.0;
  });

  setUpAll(() {
    registerFallbackValue<EnumOrderTypes>(EnumOrderTypes.market);
    registerFallbackValue<EnumBuySell>(EnumBuySell.buy);
  });

  group(
    'OrderCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, OrderInitial());
      });

      blocTest<OrderCubit, OrderState>(
        'Order placed successfully',
        build: () {
          when(
            () => _mockPlaceOrderUsecase(
              price: any(named: 'price'),
              orderType: any(named: 'orderType'),
              quoteAsset: any(named: 'quoteAsset'),
              nonce: any(named: 'nonce'),
              orderSide: any(named: 'orderSide'),
              quantity: any(named: 'quantity'),
              baseAsset: any(named: 'baseAsset'),
            ),
          ).thenAnswer(
            (_) async => Right('test'),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.placeOrder(
            nonce: nonce,
            baseAsset: baseAsset,
            quoteAsset: quoteAsset,
            orderType: orderType,
            orderSide: orderSide,
            price: price,
            quantity: quantity,
          );
        },
        expect: () => [
          isA<OrderLoading>(),
          isA<OrderAccepted>(),
        ],
      );

      blocTest<OrderCubit, OrderState>(
        'Order placement failed',
        build: () {
          when(
            () => _mockPlaceOrderUsecase(
              price: any(named: 'price'),
              orderType: any(named: 'orderType'),
              quoteAsset: any(named: 'quoteAsset'),
              nonce: any(named: 'nonce'),
              orderSide: any(named: 'orderSide'),
              quantity: any(named: 'quantity'),
              baseAsset: any(named: 'baseAsset'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError()),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.placeOrder(
            nonce: nonce,
            baseAsset: baseAsset,
            quoteAsset: quoteAsset,
            orderType: orderType,
            orderSide: orderSide,
            price: price,
            quantity: quantity,
          );
        },
        expect: () => [
          isA<OrderLoading>(),
          isA<OrderNotAccepted>(),
        ],
      );
    },
  );
}
