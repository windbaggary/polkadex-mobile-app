import 'package:flutter/material.dart';
import 'package:polkadex/common/navigation/routes.dart';

abstract class Coordinator {
  static final _navigationKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  static void goToBackupMnemonic(ChangeNotifier provider) {
    _navigationKey.currentState
        ?.pushNamed(Routes.backupMnemonicScreen, arguments: provider);
  }

  static void goToimportWalletMethods() {
    _navigationKey.currentState?.pushNamed(Routes.importWalletMethodsScreen);
  }

  static void goToMnemonicGeneratedScreen() {
    _navigationKey.currentState?.pushNamed(
      Routes.mnemonicGeneratedScreen,
    );
  }

  static void goToRestoreExistingWalletScreen() {
    _navigationKey.currentState?.pushNamed(
      Routes.restoreExistingWalletScreen,
    );
  }

  static void goToWalletSettingsScreen(ChangeNotifier provider) {
    _navigationKey.currentState
        ?.pushNamed(Routes.walletSettingsScreen, arguments: provider);
  }

  static void goToIntroScreen() {
    _navigationKey.currentState
        ?.pushNamedAndRemoveUntil(Routes.introScreen, (route) => false);
  }
}
