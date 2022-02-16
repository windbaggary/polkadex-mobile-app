import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';
import 'package:polkadex/features/landing/domain/usecases/test_deposit_usecase.dart';

class _BalanceRepositoryMock extends Mock implements IBalanceRepository {}

void main() {
  late TestDepositUseCase _usecase;
  late _BalanceRepositoryMock _repository;
  late String address;
  late String signature;

  setUp(() {
    _repository = _BalanceRepositoryMock();
    _usecase = TestDepositUseCase(balanceRepository: _repository);
    address = 'addressTest';
    signature = 'signatureTest';
  });

  group('TestDepositUseCase tests', () {
    test(
      "must test a deposit successfully",
      () async {
        // arrange
        when(() => _repository.testDeposit(
              any(),
              any(),
              any(),
            )).thenAnswer(
          (_) async => Right('ok'),
        );
        String? depositResult;
        // act
        final result = await _usecase(
          asset: 0,
          address: address,
          signature: signature,
        );
        // assert

        result.fold(
          (_) => null,
          (depositMsg) => depositResult = depositMsg,
        );

        expect(depositResult, 'ok');
        verify(() => _repository.testDeposit(any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to test a deposit",
      () async {
        // arrange
        when(() => _repository.testDeposit(any(), any(), any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(
          asset: 0,
          address: address,
          signature: signature,
        );
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.testDeposit(any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
