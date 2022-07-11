import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/models/balance_model.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_live_data_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/setup/domain/usecases/register_user_usecase.dart';
import 'package:test/test.dart';

class _MockGetBalanceUsecase extends Mock implements GetBalanceUseCase {}

class _MockGetBalanceLiveDataUsecase extends Mock
    implements GetBalanceUpdatesUseCase {}

class _MockRegisterUserUseCase extends Mock implements RegisterUserUseCase {}

void main() {
  late _MockGetBalanceUsecase _mockGetBalanceUsecase;
  late _MockGetBalanceLiveDataUsecase _mockGetBalanceLiveDataUsecase;
  late _MockRegisterUserUseCase _mockRegisterUserUseCase;
  late BalanceCubit cubit;
  late String address;
  late BalanceEntity balance;

  setUp(() {
    _mockGetBalanceUsecase = _MockGetBalanceUsecase();
    _mockGetBalanceLiveDataUsecase = _MockGetBalanceLiveDataUsecase();
    _mockRegisterUserUseCase = _MockRegisterUserUseCase();

    cubit = BalanceCubit(
      getBalanceUseCase: _mockGetBalanceUsecase,
      getBalanceUpdatesUseCase: _mockGetBalanceLiveDataUsecase,
      registerUserUseCase: _mockRegisterUserUseCase,
    );

    address = 'addressTest';
    balance = BalanceModel(
      free: {"BTC": 0.0},
      reserved: {"BTC": 0.0},
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
            () => _mockGetBalanceUsecase(address: any(named: 'address')),
          ).thenAnswer(
            (_) async => Right(balance),
          );
          when(
            () => _mockGetBalanceLiveDataUsecase(
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
            (_) async => Left(ApiError(message: '')),
          );
          when(
            () => _mockGetBalanceLiveDataUsecase(
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
          await cubit.getBalance(address);
        },
        expect: () => [
          isA<BalanceLoading>(),
          isA<BalanceError>(),
        ],
      );
    },
  );
}
