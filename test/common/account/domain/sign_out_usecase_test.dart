import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_out_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late SignOutUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late ApiError tError;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = SignOutUseCase(accountRepository: _repository);
    tError = ApiError(message: '');
  });

  group('SignOutUseCase tests', () {
    test(
      'must have success on signing out',
      () async {
        // arrange
        when(() => _repository.signOut()).thenAnswer(
          (_) async => Right(unit),
        );
        // act
        final result = await _usecase();
        // assert

        late Unit resultAccount;

        result.fold(
          (_) => null,
          (result) => resultAccount = result,
        );

        expect(resultAccount, unit);
        verify(() => _repository.signOut()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail on signing out',
      () async {
        // arrange
        when(() => _repository.signOut()).thenAnswer(
          (_) async => Left(tError),
        );
        // act
        final result = await _usecase();
        // assert

        late ApiError error;

        result.fold(
          (resultError) => error = resultError,
          (_) => null,
        );

        expect(error, tError);
        verify(() => _repository.signOut()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
