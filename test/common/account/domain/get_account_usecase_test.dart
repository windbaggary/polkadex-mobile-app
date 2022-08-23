import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late GetAccountUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late String tProxyAddress;
  late AccountEntity tAccount;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = GetAccountUseCase(accountRepository: _repository);
    tProxyAddress = "k9o1dxJxQE8Zwm5Fy";
    tAccount = AccountModel(
      name: '',
      email: 'test',
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      proxyAddress: tProxyAddress,
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
  });

  group('GetAccountUseCase tests', () {
    test(
      'must have success on getting the local account',
      () async {
        // arrange
        when(() => _repository.getAccountStorage()).thenAnswer(
          (_) async => tAccount,
        );
        // act
        final result = await _usecase();
        // assert

        expect(result, tAccount);
        verify(() => _repository.getAccountStorage()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must fail on getting the local account',
      () async {
        // arrange
        when(() => _repository.getAccountStorage()).thenAnswer(
          (_) async => null,
        );
        // act
        final result = await _usecase();
        // assert

        expect(result, null);
        verify(() => _repository.getAccountStorage()).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
