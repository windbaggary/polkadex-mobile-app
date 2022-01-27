import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/models/balance_model.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/test_deposit_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:test/test.dart';

class _MockGetBalanceUsecase extends Mock implements GetBalanceUseCase {}

class _MockTestDepositUsecase extends Mock implements TestDepositUseCase {}

void main() {
  late _MockGetBalanceUsecase _mockGetBalanceUsecase;
  late _MockTestDepositUsecase _mockTestDepositUsecase;
  late BalanceCubit cubit;
  late String address;
  late String signature;
  late BalanceEntity balance;

  setUp(() {
    _mockGetBalanceUsecase = _MockGetBalanceUsecase();
    _mockTestDepositUsecase = _MockTestDepositUsecase();

    cubit = BalanceCubit(
      getBalanceUseCase: _mockGetBalanceUsecase,
      testDepositUseCase: _mockTestDepositUsecase,
    );

    address = 'addressTest';
    signature = 'signatureTest';
    balance = BalanceModel(
      free: {"BTC": 0.0},
      used: {"BTC": 0.0},
      total: {"BTC": 0.0},
    );
  });

  BalanceEntity _increaseBalance() {
    final newBalance = BalanceModel(
      free: {"BTC": balance.free["BTC"] + 1000.0},
      used: {"BTC": balance.used["BTC"] + 1000.0},
      total: {"BTC": balance.total["BTC"] + 1000.0},
    );
    balance = newBalance;

    return newBalance;
  }

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

      blocTest<BalanceCubit, BalanceState>(
        'Test balance successful',
        build: () {
          when(
            () => _mockGetBalanceUsecase(
              address: any(named: 'address'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Right(_increaseBalance()),
          );
          when(
            () => _mockTestDepositUsecase(
              address: any(named: 'address'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Right('ok'),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getBalance(
            address,
            signature,
          );
          await cubit.testDeposit(
            address,
            signature,
          );
        },
        expect: () => [
          BalanceLoading(),
          BalanceLoaded(
            free: {"BTC": balance.free["BTC"] - 1000.0},
            total: {"BTC": balance.total["BTC"] - 1000.0},
            used: {"BTC": balance.used["BTC"] - 1000.0},
          ),
          BalanceLoading(),
          BalanceLoaded(
            free: balance.free,
            total: balance.total,
            used: balance.used,
          ),
        ],
      );

      blocTest<BalanceCubit, BalanceState>(
        'Test balance failed',
        build: () {
          when(
            () => _mockGetBalanceUsecase(
              address: any(named: 'address'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Right(balance),
          );
          when(
            () => _mockTestDepositUsecase(
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
          await cubit.testDeposit(
            address,
            signature,
          );
        },
        expect: () => [
          BalanceLoading(),
          BalanceLoaded(
            free: balance.free,
            total: balance.total,
            used: balance.used,
          ),
          BalanceLoading(),
          BalanceLoaded(
            free: balance.free,
            total: balance.total,
            used: balance.used,
          ),
        ],
      );
    },
  );
}
