import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

void main() {
  late ImportedAccountModel tImportedAccount;

  setUp(() {
    tImportedAccount = ImportedAccountModel(
      email: "",
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      proxyAddress: "k9o1dxJxQE8Zwm5Fy",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
  });

  test('ImportAccountModel must be a ImportAccountEntity', () async {
    expect(tImportedAccount, isA<ImportedAccountEntity>());
  });
}
