import 'package:test/test.dart';
import 'package:polkadex/features/setup/presentation/providers/wallet_settings_provider.dart';

void main() {
  late WalletSettingsProvider _provider;

  setUp(() {
    _provider = WalletSettingsProvider();
  });

  group(
    'WalletSettingsProvider provider test',
    () {
      test(
        'password must have at least 1 lowercase letter',
        () async {
          // act
          _provider.evalNextEnabled('testName', 'a', 'a');
          // assert

          expect(_provider.isNextEnabled, false);
          expect(_provider.hasLeast1LowercaseLetter, true);
        },
      );

      test(
        'password must have at least 1 uppercase letter',
        () async {
          // act
          _provider.evalNextEnabled('testName', 'aA', 'aA');
          // assert

          expect(_provider.isNextEnabled, false);
          expect(_provider.hasLeast1Uppercase, true);
        },
      );

      test(
        'password must have at least 1 digit',
        () async {
          // act
          _provider.evalNextEnabled('testName', 'aA123', 'aA123');
          // assert

          expect(_provider.isNextEnabled, false);
          expect(_provider.hasLeast1Digit, true);
        },
      );

      test(
        'password must have at least 8 characters',
        () async {
          // act
          _provider.evalNextEnabled('testName', 'aa123456', 'aa123456');
          // assert

          expect(_provider.isNextEnabled, false);
          expect(_provider.hasLeast8Characters, true);
        },
      );

      test(
        'user must provide a wallet name',
        () async {
          // act
          _provider.evalNextEnabled('', 'aA123456', 'aA123456');
          // assert

          expect(_provider.hasLeast1LowercaseLetter, true);
          expect(_provider.hasLeast1Uppercase, true);
          expect(_provider.hasLeast1Digit, true);
          expect(_provider.hasLeast8Characters, true);
          expect(_provider.isNextEnabled, false);
        },
      );

      test(
        'validation success for wallet beign created',
        () async {
          // act
          _provider.evalNextEnabled('testName', 'aA123456', 'aA123456');
          // assert

          expect(_provider.isNextEnabled, true);
        },
      );
    },
  );
}
