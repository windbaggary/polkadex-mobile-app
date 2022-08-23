import 'package:flutter_test/flutter_test.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/setup/data/models/imported_account_model.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';

void main() {
  late AccountModel tAccount;

  setUp(() {
    tAccount = AccountModel(
      name: "",
      email: "",
      mainAddress: "k9o1dxJxQE8Zwm5Fy",
      proxyAddress: "k9o1dxJxQE8Zwm5Fy",
      biometricAccess: false,
      timerInterval: EnumTimerIntervalTypes.oneMinute,
    );
  });

  test('AccountModel must be a AccountEntity', () async {
    expect(tAccount, isA<AccountEntity>());
  });
}
