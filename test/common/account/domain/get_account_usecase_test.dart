import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/account_model.dart';
import 'package:polkadex/features/setup/data/models/imported_trade_account_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'package:polkadex/features/setup/domain/entities/account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/imported_trade_account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';

class _AccountRepositoryMock extends Mock implements IAccountRepository {}

void main() {
  late GetAccountUseCase _usecase;
  late _AccountRepositoryMock _repository;
  late String tAddress;
  late MetaEntity tMeta;
  late EncodingEntity tEncoding;
  late AccountEntity tAccount;
  late ImportedTradeAccountEntity tImportedTradeAccount;

  setUp(() {
    _repository = _AccountRepositoryMock();
    _usecase = GetAccountUseCase(accountRepository: _repository);
    tAddress = 'k9o1dxJxQE8Zwm5Fy';
    tMeta = MetaModel(name: 'userName');
    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );
    tImportedTradeAccount = ImportedTradeAccountModel(
      address: tAddress,
      encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      encoding: tEncoding,
      meta: tMeta,
    );
    tAccount = AccountModel(
      name: "",
      email: "",
      mainAddress: tAddress,
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
      importedTradeAccountEntity: tImportedTradeAccount,
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
