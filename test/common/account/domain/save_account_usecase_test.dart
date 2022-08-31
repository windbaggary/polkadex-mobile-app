import 'dart:convert';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/account_model.dart';
import 'package:polkadex/features/setup/domain/entities/account_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late SaveAccountUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late String tEmail;
  late AccountEntity tAccount;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = SaveAccountUseCase(accountRepository: _repository);
    tEmail = "test@test.com";
    tAccount = AccountModel(
      name: "",
      email: tEmail,
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
  });

  group('SavePasswordUseCase tests', () {
    test(
      'must have success on saving an account',
      () async {
        // arrange
        when(() => _repository.saveAccountStorage(any())).thenAnswer(
          (_) async => true,
        );
        // act
        await _usecase(keypairJson: json.encode(tAccount));
        // assert

        verify(() => _repository.saveAccountStorage(json.encode(tAccount)))
            .called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
