import 'package:flutter/material.dart';
import 'package:polkadex/common/navigation/routes.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/screens/market_token_selection_screen.dart';
import 'package:polkadex/features/setup/domain/entities/imported_account_entity.dart';
import 'package:polkadex/features/trade/presentation/widgets/card_flip_widgett.dart';

abstract class Coordinator {
  static final _navigationKey = GlobalKey<NavigatorState>();

  static GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  static void goToBackupMnemonic(ChangeNotifier provider) {
    _navigationKey.currentState?.pushNamed(
      Routes.backupMnemonicScreen,
      arguments: provider,
    );
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
    _navigationKey.currentState?.pushNamed(
      Routes.walletSettingsScreen,
      arguments: provider,
    );
  }

  static void goToIntroScreen() {
    _navigationKey.currentState?.pushNamedAndRemoveUntil(
      Routes.introScreen,
      (route) => false,
    );
  }

  static void goToPrivacyPolicyScreen() {
    _navigationKey.currentState?.pushNamed(Routes.privacyPolicyScreen);
  }

  static void goToCoinWithdrawScreen({
    required String tokenId,
    required BalanceCubit balanceCubit,
  }) {
    _navigationKey.currentState?.pushNamed(
      Routes.coinWithdrawScreen,
      arguments: {
        'tokenId': tokenId,
        'balanceCubit': balanceCubit,
      },
    );
  }

  static void goToCoinTradeScreen({
    required BalanceCubit balanceCubit,
    required OrderbookCubit orderbookCubit,
    required String leftTokenId,
    required String rightTokenId,
    EnumCardFlipState? enumCardFlipState,
  }) {
    _navigationKey.currentState?.pushNamed(
      Routes.coinTradeScreen,
      arguments: {
        'orderbookCubit': orderbookCubit,
        'balanceCubit': balanceCubit,
        'enumCardFlipState': enumCardFlipState ?? EnumCardFlipState.showFirst,
        'leftTokenId': leftTokenId,
        'rightTokenId': rightTokenId,
      },
    );
  }

  static void goToBalanceDepositScreenOne(
      {required String tokenId, required BalanceCubit balanceCubit}) {
    _navigationKey.currentState
        ?.pushNamed(Routes.balanceDepositScreenOne, arguments: {
      'tokenId': tokenId,
      'balanceCubit': balanceCubit,
    });
  }

  static void goToNotifDepositScreen(
      {required EnumDepositScreenTypes enumDepositScreenTypes}) {
    _navigationKey.currentState?.pushNamed(
      Routes.notifDepositScreen,
      arguments: enumDepositScreenTypes,
    );
  }

  static void goToNotifDetailsScreen() {
    _navigationKey.currentState?.pushNamed(Routes.notifDetailsScreen);
  }

  static void goToBalanceCoinPreviewScreen({
    required String tokenId,
    required BalanceCubit balanceCubit,
    required OrderbookCubit orderbookCubit,
  }) {
    _navigationKey.currentState?.pushNamed(
      Routes.balanceCoinPreviewScreen,
      arguments: {
        'tokenId': tokenId,
        'balanceCubit': balanceCubit,
        'orderbookCubit': orderbookCubit,
      },
    );
  }

  static Future<MarketSelectionResultModel?>
      goToMarketTokenSelectionScreen() async {
    return await _navigationKey.currentState
        ?.pushNamed(Routes.marketTokenSelectionScreen);
  }

  static void goToAppSettingsHelpScreen() {
    _navigationKey.currentState?.pushNamed(Routes.appSettingsHelpScreen);
  }

  static void goToBalanceSummaryScreen() {
    _navigationKey.currentState?.pushNamed(Routes.balanceSummaryScreen);
  }

  static Future<String?> goToQrCodeScanScreen() async {
    return await _navigationKey.currentState
        ?.pushNamed(Routes.qrCodeScanScreen);
  }

  static void goToTermsConditionsScreen() {
    _navigationKey.currentState?.pushNamed(Routes.termsConditionsScreen);
  }

  static void goToMyAccountScreen() {
    _navigationKey.currentState?.pushNamed(Routes.myAccountScreen);
  }

  static void goToAppSettingsNotificationScreen() {
    _navigationKey.currentState
        ?.pushNamed(Routes.appSettingsNotificationScreen);
  }

  static void goToAppSettingsAppearanceScreen() {
    _navigationKey.currentState?.pushNamed(Routes.appSettingsAppearanceScreen);
  }

  static void goToAppSettingsLangCurrScreen() {
    _navigationKey.currentState?.pushNamed(Routes.appSettingsLangCurrScreen);
  }

  static void goToAppSettingsChangeLogsScreen() {
    _navigationKey.currentState?.pushNamed(Routes.appSettingsChangeLogsScreen);
  }

  static void goToAppSettingsSecurityScreen() {
    _navigationKey.currentState?.pushNamed(Routes.appSettingsSecurityScreen);
  }

  static void goToLandingScreen(ImportedAccountEntity account) {
    _navigationKey.currentState?.pushNamedAndRemoveUntil(
      Routes.landingScreen,
      (route) => route.isFirst,
      arguments: account,
    );
  }

  static void goBackToLandingScreen() {
    _navigationKey.currentState?.popUntil(
      (route) => route.settings.name == Routes.landingScreen,
    );
  }

  static void goToConfirmPasswordScreen() {
    _navigationKey.currentState?.pushNamed(Routes.confirmPasswordScreen);
  }
}
