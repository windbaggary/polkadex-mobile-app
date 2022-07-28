import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/coin/domain/usecases/withdraw_usecase.dart';
import 'package:polkadex/features/coin/presentation/cubits/withdraw_cubit/withdraw_cubit.dart';
import 'package:test/test.dart';

class _MockWithdrawUsecase extends Mock implements WithdrawUseCase {}

void main() {
  late _MockWithdrawUsecase _mockWithdrawUsecase;
  late WithdrawCubit cubit;
  late String asset;
  late double amountFree;
  late double amountToBeWithdrawn;
  late String proxyAddress;
  late String mainAddress;

  setUp(() {
    _mockWithdrawUsecase = _MockWithdrawUsecase();

    cubit = WithdrawCubit(
      withdrawUseCase: _mockWithdrawUsecase,
    );

    asset = 'PDEX';
    amountFree = 10.0;
    amountToBeWithdrawn = 1.0;
    proxyAddress = 'proxyAddressTest';
    mainAddress = 'mainAddressTest';
  });

  group(
    'PlaceOrderCubit tests',
    () {
      test('Verifies initial state', () {
        expect(
            cubit.state,
            WithdrawInitial(
              amountFree: 0.0,
              amountToBeWithdrawn: 0.0,
            ));
      });

      blocTest<WithdrawCubit, WithdrawState>(
        'Withdrawn cubit initialization',
        build: () {
          return cubit;
        },
        act: (cubit) async {
          cubit.init(
            amountFree: amountFree,
            amountToBeWithdrawn: 0.0,
          );
        },
        expect: () => [
          isA<WithdrawNotValid>(),
        ],
      );

      blocTest<WithdrawCubit, WithdrawState>(
        'Withdrawn parameters update',
        build: () {
          return cubit;
        },
        act: (cubit) async {
          cubit.init(
            amountFree: amountFree,
            amountToBeWithdrawn: 0.0,
          );
          cubit.updateWithdrawParams(
            amountToBeWithdrawn: 2.0,
          );
        },
        expect: () => [
          WithdrawNotValid(
            amountFree: amountFree,
            amountToBeWithdrawn: 0.0,
          ),
          WithdrawValid(
            amountFree: amountFree,
            amountToBeWithdrawn: 2.0,
          ),
        ],
      );

      blocTest<WithdrawCubit, WithdrawState>(
        'Withdrawn successfully',
        build: () {
          when(
            () => _mockWithdrawUsecase(
              proxyAddress: any(named: 'proxyAddress'),
              mainAddress: any(named: 'mainAddress'),
              asset: any(named: 'asset'),
              amount: any(named: 'amount'),
            ),
          ).thenAnswer(
            (_) async => Right(null),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.withdraw(
            proxyAddress: proxyAddress,
            mainAddress: mainAddress,
            asset: asset,
            amountToBeWithdrawn: amountToBeWithdrawn,
            amountFree: amountFree,
          );
        },
        expect: () => [
          isA<WithdrawLoading>(),
          isA<WithdrawSuccess>(),
        ],
      );

      blocTest<WithdrawCubit, WithdrawState>(
        'Withdraw failed',
        build: () {
          when(
            () => _mockWithdrawUsecase(
              proxyAddress: any(named: 'proxyAddress'),
              mainAddress: any(named: 'mainAddress'),
              asset: any(named: 'asset'),
              amount: any(named: 'amount'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: '')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.withdraw(
            proxyAddress: proxyAddress,
            mainAddress: mainAddress,
            asset: asset,
            amountToBeWithdrawn: amountToBeWithdrawn,
            amountFree: amountFree,
          );
        },
        expect: () => [
          isA<WithdrawLoading>(),
          isA<WithdrawError>(),
        ],
      );
    },
  );
}
