import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/encoding_model.dart';
import 'package:polkadex/features/setup/data/models/account_model.dart';
import 'package:polkadex/features/setup/data/models/imported_trade_account_model.dart';
import 'package:polkadex/features/setup/data/models/meta_model.dart';
import 'package:polkadex/features/setup/domain/entities/account_entity.dart';
import 'package:polkadex/features/setup/domain/entities/imported_trade_account_entity.dart';

void main() {
  late String tAddress;
  late AccountModel tAccount;
  late MetaModel tMeta;
  late EncodingModel tEncoding;
  late ImportedTradeAccountEntity tImportedTradeAccount;

  setUp(() {
    tAddress = 'k9o1dxJxQE8Zwm5Fy';
    tEncoding = EncodingModel(
      content: ["sr25519"],
      version: '3',
      type: ["none"],
    );
    tMeta = MetaModel(name: 'userName');
    tImportedTradeAccount = ImportedTradeAccountModel(
      address: tAddress,
      encoded: "WFChrxNT3nd/UbHYklZlR3GWuoj9OhIwMhAJAx+",
      encoding: tEncoding,
      meta: tMeta,
    );
    tAccount = AccountModel(
      email: 'test@test.com',
      mainAddress: tAddress,
      name: "",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
      importedTradeAccountEntity: tImportedTradeAccount,
    );
  });

  test('AccountModel must be a AccountEntity', () async {
    expect(tAccount, isA<AccountEntity>());
  });
}
