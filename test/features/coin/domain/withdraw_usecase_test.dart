import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/coin/domain/repositories/icoin_repository.dart';
import 'package:polkadex/features/coin/domain/usecases/withdraw_usecase.dart';

class _CoinRepositoryMock extends Mock implements ICoinRepository {}

void main() {
  late WithdrawUseCase _usecase;
  late _CoinRepositoryMock _repository;
  late String asset;
  late double amount;
  late String address;

  setUp(() {
    _repository = _CoinRepositoryMock();
    _usecase = WithdrawUseCase(coinRepository: _repository);
    asset = 'PDEX';
    amount = 10.0;
    address = 'addressTest';
  });

  group('WithdrawUseCase tests', () {
    test(
      "must successfully withdraw an amount of a given asset",
      () async {
        // arrange
        when(() => _repository.withdraw(
              any(),
              any(),
              any(),
            )).thenAnswer(
          (_) async => Right('success'),
        );
        // act
        final result = await _usecase(
          amount: amount,
          asset: asset,
          address: address,
        );
        // assert
        expect(result.isRight(), true);
        verify(() => _repository.withdraw(any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to withdraw an amount of a given asset",
      () async {
        // arrange
        when(() => _repository.withdraw(any(), any(), any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(
          amount: amount,
          asset: asset,
          address: address,
        );
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.withdraw(any(), any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
