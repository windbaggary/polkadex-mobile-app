import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/data/models/order_model.dart';
import 'package:polkadex/features/landing/domain/entities/order_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/place_order_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:test/test.dart';

class _MockPlaceOrderUsecase extends Mock implements PlaceOrderUseCase {}

void main() {
  late _MockPlaceOrderUsecase _mockPlaceOrderUsecase;
  late PlaceOrderCubit cubit;
  late int nonce;
  late String baseAsset;
  late String quoteAsset;
  late EnumOrderTypes orderType;
  late EnumBuySell orderSide;
  late double quantity;
  late double price;
  late OrderEntity order;
  late String signature;

  setUp(() {
    _mockPlaceOrderUsecase = _MockPlaceOrderUsecase();

    cubit = PlaceOrderCubit(
      placeOrderUseCase: _mockPlaceOrderUsecase,
    );

    nonce = 0;
    baseAsset = "BTC";
    quoteAsset = "USD";
    orderType = EnumOrderTypes.market;
    orderSide = EnumBuySell.buy;
    quantity = 100.0;
    price = 50.0;
    signature = 'test';
    order = OrderModel(
      uuid: 'abcd',
      type: orderSide,
      amount: quantity.toString(),
      price: price.toString(),
      dateTime: DateTime.now(),
      amountCoin: baseAsset,
      priceCoin: quoteAsset,
      orderType: orderType,
      tokenPairName: '$baseAsset/$quoteAsset',
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
              price: any(named: 'price'),
              orderType: any(named: 'orderType'),
              quoteAsset: any(named: 'quoteAsset'),
              nonce: any(named: 'nonce'),
              orderSide: any(named: 'orderSide'),
              quantity: any(named: 'quantity'),
              baseAsset: any(named: 'baseAsset'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Right(order),
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
            signature: signature,
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
              price: any(named: 'price'),
              orderType: any(named: 'orderType'),
              quoteAsset: any(named: 'quoteAsset'),
              nonce: any(named: 'nonce'),
              orderSide: any(named: 'orderSide'),
              quantity: any(named: 'quantity'),
              baseAsset: any(named: 'baseAsset'),
              signature: any(named: 'signature'),
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
              signature: signature);
        },
        expect: () => [
          isA<PlaceOrderLoading>(),
          isA<PlaceOrderNotAccepted>(),
        ],
      );
    },
  );
}
