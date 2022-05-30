import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/models/balance_model.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_live_data_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/test_deposit_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/setup/domain/usecases/register_user_usecase.dart';
import 'package:test/test.dart';

class _MockGetBalanceUsecase extends Mock implements GetBalanceUseCase {}

class _MockGetBalanceLiveDataUsecase extends Mock
    implements GetBalanceLiveDataUseCase {}

class _MockTestDepositUsecase extends Mock implements TestDepositUseCase {}

class _MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

void main() {
  late _MockGetBalanceUsecase _mockGetBalanceUsecase;
  late _MockGetBalanceLiveDataUsecase _mockGetBalanceLiveDataUsecase;
  late _MockTestDepositUsecase _mockTestDepositUsecase;
  late _MockRegisterUserUseCase _mockRegisterUserUseCase;
  late BalanceCubit cubit;
  late String address;
  late String signature;
  late BalanceEntity balance;

  setUp(() {
    _mockGetBalanceUsecase = _MockGetBalanceUsecase();
    _mockGetBalanceLiveDataUsecase = _MockGetBalanceLiveDataUsecase();
    _mockTestDepositUsecase = _MockTestDepositUsecase();
    _mockRegisterUserUseCase = _MockRegisterUserUseCase();

    cubit = BalanceCubit(
      getBalanceUseCase: _mockGetBalanceUsecase,
      getBalanceLiveDataUseCase: _mockGetBalanceLiveDataUsecase,
      testDepositUseCase: _mockTestDepositUsecase,
      registerUserUseCase: _mockRegisterUserUseCase,
    );

    address = 'addressTest';
    signature = 'signatureTest';
    balance = BalanceModel(
      free: {"BTC": 0.0},
      reserved: {"BTC": 0.0},
    );
  });

  BalanceEntity _increaseBalance() {
    final newBalance = BalanceModel(
      free: {"BTC": balance.free["BTC"] + 1000.0},
      reserved: {"BTC": balance.reserved["BTC"] + 1000.0},
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
            () => _mockGetBalanceUsecase(address: any(named: 'address')),
          ).thenAnswer(
            (_) async => Right(balance),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getBalance(address);
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
            () => _mockGetBalanceUsecase(address: any(named: 'address')),
          ).thenAnswer(
            (_) async => Left(ApiError(message: 'error')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getBalance(address);
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
            () => _mockRegisterUserUseCase(
              address: any(named: 'address'),
            ),
          ).thenAnswer(
            (_) async => 'test',
          );
          when(
            () => _mockGetBalanceUsecase(address: any(named: 'address')),
          ).thenAnswer(
            (_) async => Right(_increaseBalance()),
          );
          when(
            () => _mockTestDepositUsecase(
              asset: any(named: 'asset'),
              address: any(named: 'address'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Right('ok'),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getBalance(address);
          await cubit.testDeposit(
            address,
            signature,
          );
        },
        expect: () => [
          BalanceLoading(),
          BalanceLoaded(
            free: {"BTC": balance.free["BTC"] - 1000.0},
            reserved: {"BTC": balance.reserved["BTC"] - 1000.0},
          ),
          BalanceLoading(),
          BalanceLoaded(
            free: balance.free,
            reserved: balance.reserved,
          ),
        ],
      );

      blocTest<BalanceCubit, BalanceState>(
        'Test balance failed',
        build: () {
          when(
            () => _mockRegisterUserUseCase(
              address: any(named: 'address'),
            ),
          ).thenAnswer(
            (_) async => 'test',
          );
          when(
            () => _mockGetBalanceUsecase(address: any(named: 'address')),
          ).thenAnswer(
            (_) async => Right(balance),
          );
          when(
            () => _mockTestDepositUsecase(
              asset: any(named: 'asset'),
              address: any(named: 'address'),
              signature: any(named: 'signature'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: 'error')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.getBalance(address);
          await cubit.testDeposit(
            address,
            signature,
          );
        },
        expect: () => [
          BalanceLoading(),
          BalanceLoaded(
            free: balance.free,
            reserved: balance.reserved,
          ),
          BalanceLoading(),
          BalanceLoaded(
            free: balance.free,
            reserved: balance.reserved,
          ),
        ],
      );
    },
  );
}
