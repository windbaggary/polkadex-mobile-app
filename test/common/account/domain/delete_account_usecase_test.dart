import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late DeleteAccountUseCase _usecase;
  late _AccountRepositoryMock _repository;
  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = DeleteAccountUseCase(accountRepository: _repository);
  });

  group('DeleteAccountUseCase tests', () {
    test(
      'must have success on deleting the local account',
      () async {
        // arrange
        when(() => _repository.deleteAccountStorage()).thenAnswer(
          (_) async => true,
        );
        // act
        await _usecase();
        // assert
        verify(() => _repository.deleteAccountStorage()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
