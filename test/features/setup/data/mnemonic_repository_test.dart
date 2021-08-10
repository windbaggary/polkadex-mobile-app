import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/meta_entity.dart';
import 'package:polkadex/features/setup/domain/entities/encoding_entity.dart';

class _MockMnemonicRemoteDatasource extends Mock
    implements MnemonicRemoteDatasource {}

void main() {
  late _MockMnemonicRemoteDatasource dataSource;
  late MnemonicRepository repository;
  late String tMnemonic;
  late Map<String, dynamic> tGenData;
  late Map<String, dynamic> tImportData;
  late Map<String, dynamic> tErrorData;
  late MetaEntity tMeta;
  late EncodingEntity tEncoding;
  late ImportedAccountEntity tImportedAccount;

  setUp(() {
    dataSource = _MockMnemonicRemoteDatasource();
    repository = MnemonicRepository(mnemonicRemoteDatasource: dataSource);
    tMnemonic =
        "correct gather fork rent problem ocean train pretty dinosaur captain myself rent";
    tGenData = {"mnemonic": tMnemonic};
    tImportData = {
      "pubKey": "0xe5639b03f86257d187b00b667ae58",
      "mnemonic": tMnemonic,
      "rawSeed": "",
      "encoded": "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      "encoding": {
        "content": ["sr25519"],
        "version": '3',
        "type": ["none"]
      },
      "address": "k9o1dxJxQE8Zwm5Fy",
      "meta": {"name": "userName"},
    };
    tErrorData = {"error": "errorTest"};
    tMeta = MetaModel(name: 'userName');
    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );
    tImportedAccount = ImportedAccountModel(
      pubKey: "0xe5639b03f86257d187b00b667ae58",
      mnemonic: tMnemonic,
      rawSeed: "",
      encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      encoding: tEncoding,
      address: "k9o1dxJxQE8Zwm5Fy",
      meta: tMeta,
    );
  });

  group('Mnemonic repository tests ', () {
    test('Must return a new generated mnemonic', () async {
      when(() => dataSource.generateMnemonic()).thenAnswer(
        (_) async => tGenData,
      );

      final result = await repository.generateMnemonic();

      late List<String> resultMnemonic;

      result.fold(
        (_) {},
        (generatedMnemonic) => resultMnemonic = generatedMnemonic,
      );

      expect(resultMnemonic, tMnemonic.split(' '));
      verify(() => dataSource.generateMnemonic()).called(1);
      verifyNoMoreInteractions(dataSource);
    });

    test(
      'Must return data related to the imported account from mnemonic',
      () async {
        when(() => dataSource.importAccount(any(), any())).thenAnswer(
          (_) async => tImportData,
        );

        final result = await repository.importAccount('test', '123456');

        late ImportedAccountEntity resultAcc;

        result.fold(
          (_) {},
          (acc) => resultAcc = acc,
        );

        expect(resultAcc, tImportedAccount);
        verify(() => dataSource.importAccount(any(), any())).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );

    test(
      'Must return error related to a wrong mnemonic used for import',
      () async {
        when(() => dataSource.importAccount(any(), any())).thenAnswer(
          (_) async => tErrorData,
        );

        final result = await repository.importAccount('test', '123456');

        expect(result.isLeft(), true);
        verify(() => dataSource.importAccount(any(), any())).called(1);
        verifyNoMoreInteractions(dataSource);
      },
    );
  });
}
