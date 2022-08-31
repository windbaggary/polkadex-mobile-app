import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/network/error.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/imported_trade_account_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';
import 'package:polkadex/features/setup/domain/entities/imported_trade_account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';
import 'package:polkadex/features/setup/domain/repositories/imnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/import_trade_account_usecase.dart';

class _MnemonicRepositoryMock extends Mock implements IMnemonicRepository {}

void main() {
  late ImportTradeAccountUseCase _usecase;
  late _MnemonicRepositoryMock _repository;
  late String tAddress;
  late ImportedTradeAccountEntity tImportedTradeAccount;
  late MetaEntity tMeta;
  late EncodingEntity tEncoding;

  setUp(() {
    _repository = _MnemonicRepositoryMock();
    _usecase = ImportTradeAccountUseCase(mnemonicRepository: _repository);
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
  });

  group('ImportAccountUsecase tests', () {
    test(
      'must return success on account import',
      () async {
        // arrange
        when(() => _repository.importTradeAccount(any(), any())).thenAnswer(
          (_) async => Right(tImportedTradeAccount),
        );
        // act
        final result = await _usecase(mnemonic: '', password: '');
        // assert

        late ImportedTradeAccountEntity account;

        result.fold(
          (_) => null,
          (acc) => account = acc,
        );

        expect(account, tImportedTradeAccount);
        verify(() => _repository.importTradeAccount(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );

    test(
      'must return error on account import with incorrect mnemonic',
      () async {
        // arrange
        when(() => _repository.importTradeAccount(any(), any())).thenAnswer(
          (_) async => Left(ApiError(message: '')),
        );
        // act
        final result = await _usecase(mnemonic: '', password: '');
        // assert

        expect(result.isLeft(), true);
        verify(() => _repository.importTradeAccount(any(), any())).called(1);
        verifyNoMoreInteractions(_repository);
      },
    );
  });
}
