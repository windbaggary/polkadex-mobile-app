import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/models/balance_model.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:test/test.dart';

class _MockGetBalanceUsecase extends Mock implements GetBalanceUseCase {}

void main() {
  late _MockGetBalanceUsecase _mockGetBalanceUsecase;
  late BalanceCubit cubit;
  late String address;
  late String signature;
  late BalanceEntity balance;

  setUp(() {
    _mockGetBalanceUsecase = _MockGetBalanceUsecase();

    cubit = BalanceCubit(
      getBalanceUseCase: _mockGetBalanceUsecase,
    );

    address = 'addressTest';
    signature = 'signatureTest';
    balance = BalanceModel(
      free: {"BTC": 0.1},
      used: {"BTC": 0.1},
      total: {"BTC": 0.2},
    );
  });

  group(
    'PlaceOrderCubit tests',
    () {
      test('Verifies initial state', () {
        expect(cubit.state, BalanceInitial());
      });

      blocTest<BalanceCubit, BalanceState>(
        'Balance fetched successfully',
        build: () {
          when(
            () => _mockGetBalanceUsecase(
              address: any(named: 'address'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Right(balance),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getBalance(
            address,
            signature,
          );
        },
        expect: () => [
          isA<BalanceLoading>(),
          isA<BalanceLoaded>(),
        ],
      );

      blocTest<BalanceCubit, BalanceState>(
        'Balance fetch failed',
        build: () {
          when(
            () => _mockGetBalanceUsecase(
              address: any(named: 'address'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: 'error')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getBalance(
            address,
            signature,
          );
        },
        expect: () => [
          isA<BalanceLoading>(),
          isA<BalanceError>(),
        ],
      );
    },
  );
}
