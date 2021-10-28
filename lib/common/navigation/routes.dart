import 'package:flutter/material.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/screens/backup_mnemonic_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/import_wallet_methods_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/intro_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/mnemonic_generated_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/restore_existing_wallet_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/wallet_settings_screen.dart';
import 'package:polkadex/injection_container.dart';
import 'package:provider/provider.dart';

abstract class Routes {
  static const introScreen = '/';
  static const backupMnemonicScreen = '/backupMnemonic';
  static const importWalletMethodsScreen = '/importWalletMethods';
  static const mnemonicGeneratedScreen = '/mnemonicGenerated';
  static const restoreExistingWalletScreen = '/restoreExistingWallet';
  static const walletSettingsScreen = '/walletSettings';

  static Route onGenerateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    switch (settings.name) {
      case backupMnemonicScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ChangeNotifierProvider.value(
              value: settings.arguments as MnemonicProvider,
              child: FadeTransition(
                opacity: CurvedAnimation(
                    parent: animation, curve: Interval(0.500, 1.00)),
                child: BackupMnemonicScreen(),
              ),
            );
          },
        );
      case importWalletMethodsScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Interval(0.500, 1.00)),
              child: ChangeNotifierProvider(
                create: (context) => dependency<MnemonicProvider>(),
                builder: (context, _) {
                  return ImportWalletMethodsScreen();
                },
              ),
            );
          },
        );
      case mnemonicGeneratedScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Interval(0.500, 1.00)),
              child: ChangeNotifierProvider(
                create: (context) =>
                    dependency<MnemonicProvider>()..generateMnemonic(),
                builder: (context, _) {
                  return MnemonicGeneratedScreen();
                },
              ),
            );
          },
        );
      case restoreExistingWalletScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Interval(0.500, 1.00)),
              child: ChangeNotifierProvider(
                create: (context) => dependency<MnemonicProvider>(),
                builder: (context, _) {
                  return RestoreExistingWalletScreen();
                },
              ),
            );
          },
        );
      case walletSettingsScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return ChangeNotifierProvider.value(
              value: settings.arguments as MnemonicProvider,
              child: FadeTransition(
                opacity: CurvedAnimation(
                    parent: animation, curve: Interval(0.500, 1.00)),
                child: WalletSettingsScreen(),
              ),
            );
          },
        );
      default:
        builder = (_) {
          return IntroScreen();
        };
        break;
    }

    return MaterialPageRoute<dynamic>(builder: builder, settings: settings);
  }
}
