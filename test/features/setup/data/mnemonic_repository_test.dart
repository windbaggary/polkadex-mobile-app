import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';

class _MockMnemonicRemoteDatasource extends Mock
    implements MnemonicRemoteDatasource {}

void main() {
  late _MockMnemonicRemoteDatasource dataSource;
  late MnemonicRepository repository;
  late String tMnemonic;
  late Map<String, dynamic> tGenData;
  late Map<String, dynamic> tImportData;
  late Map<String, dynamic> tErrorData;
  late AccountEntity tAccount;

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
    tAccount = AccountModel(
      name: "",
      email: "",
      mainAddress: "",
      proxyAddress: "k9o1dxJxQE8Zwm5Fy",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
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

        late AccountEntity resultAcc;

        result.fold(
          (_) {},
          (acc) => resultAcc = acc,
        );

        expect(resultAcc, tAccount);
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
