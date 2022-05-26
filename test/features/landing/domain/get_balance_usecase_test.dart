import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/data/models/balance_model.dart';
import 'package:polkadex/features/landing/domain/entities/balance_entity.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';

class _BalanceRepositoryMock extends Mock implements IBalanceRepository {}

void main() {
  late GetBalanceUseCase _usecase;
  late _BalanceRepositoryMock _repository;
  late String address;
  late BalanceEntity balance;

  setUp(() {
    _repository = _BalanceRepositoryMock();
    _usecase = GetBalanceUseCase(balanceRepository: _repository);
    address = 'addressTest';
    balance = BalanceModel(
      free: {"BTC": 0.1},
      reserved: {"BTC": 0.1},
    );
  });

  group('GetBalanceUseCase tests', () {
    test(
      "must get an account's balance successfully",
      () async {
        // arrange
        when(() => _repository.fetchBalance(any())).thenAnswer(
          (_) async => Right(balance),
        );
        BalanceEntity? balanceResult;
        // act
        final result = await _usecase(address: address);
        // assert

        result.fold(
          (_) => null,
          (balance) => balanceResult = balance,
        );

        expect(balanceResult, balance);
        verify(() => _repository.fetchBalance(any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to get an account's balance",
      () async {
        // arrange
        when(() => _repository.fetchBalance(any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(address: address);
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.fetchBalance(any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
