import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_updates_usecase.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';

class _BalanceRepositoryMock extends Mock implements IBalanceRepository {}

void main() {
  late GetBalanceUpdatesUseCase _usecase;
  late _BalanceRepositoryMock _repository;

  setUp(() {
    _repository = _BalanceRepositoryMock();
    _usecase = GetBalanceUpdatesUseCase(balanceRepository: _repository);
  });

  group('GetBalanceLiveDataUseCase tests', () {
    test(
      "must fetch balance live data",
      () async {
        // arrange
        when(() => _repository.fetchBalanceUpdates(
              any(),
              any(),
              any(),
            )).thenAnswer(
          (_) async => Right(null),
        );
        // act
        await _usecase(
          address: '',
          onMsgReceived: (_) {},
          onMsgError: (_) {},
        );

        verify(() => _repository.fetchBalanceUpdates(
              any(),
              any(),
              any(),
            )).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
