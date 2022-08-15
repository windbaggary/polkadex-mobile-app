import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/imnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/import_account_usecase.dart';

class _MnemonicRepositoryMock extends Mock implements IMnemonicRepository {}

void main() {
  late ImportAccountUseCase _usecase;
  late _MnemonicRepositoryMock _repository;
  late MetaEntity tMeta;
  late EncodingEntity tEncoding;
  late ImportedAccountEntity tImportedAccount;

  setUp(() {
    _repository = _MnemonicRepositoryMock();
    _usecase = ImportAccountUseCase(mnemonicRepository: _repository);
    tMeta = MetaModel(name: 'userName');
    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );
    tImportedAccount = ImportedAccountModel(
      encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      encoding: tEncoding,
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      proxyAddress: "k9o1dxJxQE8Zwm5Fy",
      meta: tMeta,
      name: "",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
  });

  group('ImportAccountUsecase tests', () {
    test(
      'must return success on account import',
      () async {
        // arrange
        when(() => _repository.importAccount(any(), any())).thenAnswer(
          (_) async => Right(tImportedAccount),
        );
        // act
        final result = await _usecase(mnemonic: '', password: '');
        // assert

        late ImportedAccountEntity importedAccount;

        result.fold(
          (_) => null,
          (acc) => importedAccount = acc,
        );

        expect(importedAccount, tImportedAccount);
        verify(() => _repository.importAccount(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must return error on account import with incorrect mnemonic',
      () async {
        // arrange
        when(() => _repository.importAccount(any(), any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(mnemonic: '', password: '');
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.importAccount(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
