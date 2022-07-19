import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/orderbook/data/models/orderbook_model.dart';
import 'package:polkadex/common/orderbook/domain/entities/orderbook_entity.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/common/orderbook/domain/usecases/get_orderbook_data_usecase.dart';
import 'package:polkadex/common/orderbook/domain/usecases/get_orderbook_updates_usecase.dart';
import 'package:test/test.dart';

class _MockFetchOrderbookDataUseCase extends Mock
    implements GetOrderbookDataUseCase {}

class _MockGetOrderbookLiveDataUseCase extends Mock
    implements GetOrderbookUpdatesUseCase {}

void main() {
  late _MockFetchOrderbookDataUseCase _mockFetchOrderbookDataUseCase;
  late _MockGetOrderbookLiveDataUseCase _mockFetchOrderbookLiveDataUseCase;
  late OrderbookCubit cubit;
  late OrderbookEntity tOrderbook;

  setUp(() {
    _mockFetchOrderbookDataUseCase = _MockFetchOrderbookDataUseCase();
    _mockFetchOrderbookLiveDataUseCase = _MockGetOrderbookLiveDataUseCase();

    cubit = OrderbookCubit(
      fetchOrderbookDataUseCase: _mockFetchOrderbookDataUseCase,
      fetchOrderbookUpdatesUseCase: _mockFetchOrderbookLiveDataUseCase,
    );

    tOrderbook = OrderbookModel(
      ask: [],
      bid: [],
    );
  });

  group(
    'OrderbookCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, OrderbookInitial());
      });

      blocTest<OrderbookCubit, OrderbookState>(
        'Orderbook data fetched successfully',
        build: () {
          when(
            () => _mockFetchOrderbookDataUseCase(
              leftTokenId: any(named: 'leftTokenId'),
              rightTokenId: any(named: 'rightTokenId'),
            ),
          ).thenAnswer(
            (_) async => Right(tOrderbook),
          );
          when(
            () => _mockFetchOrderbookLiveDataUseCase(
              leftTokenId: any(named: 'leftTokenId'),
              rightTokenId: any(named: 'rightTokenId'),
              onMsgReceived: any(named: 'onMsgReceived'),
              onMsgError: any(named: 'onMsgError'),
            ),
          ).thenAnswer(
            (_) async => Right(null),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchOrderbookData(
            leftTokenId: '0',
            rightTokenId: '1',
          );
        },
        expect: () => [
          OrderbookLoading(),
          OrderbookLoaded(orderbook: tOrderbook),
        ],
      );

      blocTest<OrderbookCubit, OrderbookState>(
        'Orderbook data fetch fail',
        build: () {
          when(
            () => _mockFetchOrderbookDataUseCase(
              leftTokenId: any(named: 'leftTokenId'),
              rightTokenId: any(named: 'rightTokenId'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: '')),
          );
          when(
            () => _mockFetchOrderbookLiveDataUseCase(
              leftTokenId: any(named: 'leftTokenId'),
              rightTokenId: any(named: 'rightTokenId'),
              onMsgReceived: any(named: 'onMsgReceived'),
              onMsgError: any(named: 'onMsgError'),
            ),
          ).thenAnswer(
            (_) async => Right(null),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.fetchOrderbookData(
            leftTokenId: '0',
            rightTokenId: '1',
          );
        },
        expect: () => [
          OrderbookLoading(),
          OrderbookError(errorMessage: ''),
        ],
      );

      //blocTest<OrderbookCubit, OrderbookState>(
      //  'Orderbook live data fetch fail',
      //  build: () {
      //    when(
      //      () => _mockFetchOrderbookDataUseCase(
      //        leftTokenId: any(named: 'leftTokenId'),
      //        rightTokenId: any(named: 'rightTokenId'),
      //      ),
      //    ).thenAnswer(
      //      (_) async => Right(tOrderbook),
      //    );
      //    when(
      //      () => _mockFetchOrderbookLiveDataUseCase(
      //        leftTokenId: any(named: 'leftTokenId'),
      //        rightTokenId: any(named: 'rightTokenId'),
      //        onMsgReceived: any(named: 'onMsgReceived'),
      //        onMsgError: any(named: 'onMsgError'),
      //      ),
      //    ).thenAnswer(
      //      (_) async => Left(ApiError(message: '')),
      //    );
      //    return cubit;
      //  },
      //  act: (cubit) async {
      //    await cubit.fetchOrderbookData(
      //      leftTokenId: '0',
      //      rightTokenId: '1',
      //    );
      //  },
      //  expect: () => [
      //    OrderbookLoading(),
      //    OrderbookError(errorMessage: ''),
      //  ],
      //);
    },
  );
}
