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
      pubKey: "0xe5639b03f86257d187b00b667ae58",
      mnemonic: "test",
      rawSeed: "",
      encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      encoding: tEncoding,
      address: "k9o1dxJxQE8Zwm5Fy",
      meta: tMeta,
    );
  });

  test('ImportAccountModel must be a ImportAccountEntity', () async {
    expect(tImportedAccount, isA<ImportedAccountEntity>());
  });
}
