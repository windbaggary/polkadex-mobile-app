import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_live_data_usecase.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';

class _BalanceRepositoryMock extends Mock implements IBalanceRepository {}

void main() {
  late GetBalanceLiveDataUseCase _usecase;
  late _BalanceRepositoryMock _repository;

  setUp(() {
    _repository = _BalanceRepositoryMock();
    _usecase = GetBalanceLiveDataUseCase(balanceRepository: _repository);
  });

  group('GetBalanceLiveDataUseCase tests', () {
    test(
      "must fetch balance live data",
      () async {
        // arrange
        when(() => _repository.fetchBalanceLiveData(
              any(),
              any(),
              any(),
            )).thenAnswer(
          (_) async => Right(null),
        );
        // act
        final result = await _usecase(
          address: '',
          onMsgReceived: () {},
          onMsgError: (_) {},
        );

        expect(result.isRight(), true);
        verify(() => _repository.fetchBalanceLiveData(
              any(),
              any(),
              any(),
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      "must fail to fetch balance live data",
      () async {
        // arrange
        when(() => _repository.fetchBalanceLiveData(
              any(),
              any(),
              any(),
            )).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        ApiError? orderbookResult;
        // act
        final result = await _usecase(
          address: '',
          onMsgReceived: () {},
          onMsgError: (_) {},
        );
        // assert
        result.fold(
          (error) => orderbookResult = error,
          (_) => null,
        );

        expect(orderbookResult != null, true);
        verify(() => _repository.fetchBalanceLiveData(
              any(),
              any(),
              any(),
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
