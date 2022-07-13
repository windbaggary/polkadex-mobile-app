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
  late String address;

  setUp(() {
    _mockWithdrawUsecase = _MockWithdrawUsecase();

    cubit = WithdrawCubit(
      withdrawUseCase: _mockWithdrawUsecase,
    );

    asset = 'PDEX';
    amountFree = 10.0;
    amountToBeWithdrawn = 1.0;
    address = 'addressTest';
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
              amountDisplayed: '0',
              address: '',
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
            amountDisplayed: '',
            address: '',
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
            amountDisplayed: '',
            address: '',
          );
          cubit.updateWithdrawParams(
            amountToBeWithdrawn: 2.0,
            amountDisplayed: '2',
          );
        },
        expect: () => [
          WithdrawNotValid(
            amountFree: amountFree,
            amountToBeWithdrawn: 0.0,
            amountDisplayed: '',
            address: '',
          ),
          WithdrawNotValid(
            amountFree: amountFree,
            amountToBeWithdrawn: 2.0,
            amountDisplayed: '2',
            address: '',
          ),
        ],
      );

      blocTest<WithdrawCubit, WithdrawState>(
        'Withdrawn successfully',
        build: () {
          when(
            () => _mockWithdrawUsecase(
              asset: any(named: 'asset'),
              amount: any(named: 'amount'),
              address: any(named: 'address'),
            ),
          ).thenAnswer(
            (_) async => Right('test'),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.withdraw(
            asset: asset,
            amountToBeWithdrawn: amountToBeWithdrawn,
            amountFree: amountFree,
            address: address,
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
              asset: any(named: 'asset'),
              amount: any(named: 'amount'),
              address: any(named: 'address'),
            ),
          ).thenAnswer(
            (_) async => Left(ApiError(message: '')),
          );
          return cubit;
        },
        act: (cubit) async {
          await cubit.withdraw(
            asset: asset,
            amountToBeWithdrawn: amountToBeWithdrawn,
            amountFree: amountFree,
            address: address,
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
