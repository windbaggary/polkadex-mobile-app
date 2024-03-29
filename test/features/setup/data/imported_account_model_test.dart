import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

void main() {
  late MetaModel tMeta;
  late EncodingModel tEncoding;
  late ImportedAccountModel tImportedAccount;

  setUp(() {
    tMeta = MetaModel(name: 'userName');

    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );

    tImportedAccount = ImportedAccountModel(
        encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
        encoding: tEncoding,
        address: "k9o1dxJxQE8Zwm5Fy",
        meta: tMeta,
        name: "test",
        biometricAccess: false,
        signature: '');
  });

  test('ImportAccountModel must be a ImportAccountEntity', () async {
    expect(tImportedAccount, isA<ImportedAccountEntity>());
  });
}
