import 'package:flutter/material.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/widgets/qr_code_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_appearance.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_change_logs_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_help_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_lang_curr.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_notif_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/app_settings_security.dart';
import 'package:polkadex/features/app_settings_info/screens/my_account_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/privacy_policy_screen.dart';
import 'package:polkadex/features/app_settings_info/screens/terms_conditions_screen.dart';
import 'package:polkadex/features/balance/screens/balance_coin_preview_screen.dart';
import 'package:polkadex/features/balance/screens/balance_deposit_screen_1.dart';
import 'package:polkadex/features/balance/screens/balance_summary_screen.dart';
import 'package:polkadex/features/balance/screens/coin_withdraw_screen.dart';
import 'package:polkadex/features/landing/presentation/screens/landing_screen.dart';
import 'package:polkadex/features/landing/presentation/screens/market_token_selection_screen.dart';
import 'package:polkadex/features/notifications/screens/notif_deposit_screen.dart';
import 'package:polkadex/features/notifications/screens/notif_details_screen.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/screens/auth_logout_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/backup_mnemonic_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/confirm_password_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/import_wallet_methods_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/intro_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/mnemonic_generated_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/restore_existing_wallet_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/wallet_settings_screen.dart';
import 'package:polkadex/features/trade/screens/coin_trade_screen.dart';
import 'package:polkadex/features/trade/widgets/card_flip_widgett.dart';
import 'package:polkadex/injection_container.dart';
import 'package:provider/provider.dart';

abstract class Routes {
  static const authLogoutScreen = '/';
  static const introScreen = '/intro';
  static const backupMnemonicScreen = '/backupMnemonic';
  static const importWalletMethodsScreen = '/importWalletMethods';
  static const mnemonicGeneratedScreen = '/mnemonicGenerated';
  static const restoreExistingWalletScreen = '/restoreExistingWallet';
  static const walletSettingsScreen = '/walletSettings';
  static const privacyPolicyScreen = '/privacyPolicy';
  static const coinWithdrawScreen = '/coinWithdraw';
  static const coinTradeScreen = '/coinTrade';
  static const balanceDepositScreenOne = '/balanceDepositOne';
  static const notifDepositScreen = '/notifDeposit';
  static const notifDetailsScreen = '/notifDetails';
  static const balanceCoinPreviewScreen = '/balanceCoinPreview';
  static const marketTokenSelectionScreen = '/marketTokenSelection';
  static const appSettingsHelpScreen = '/appSettingsHelp';
  static const balanceSummaryScreen = '/balanceSummary';
  static const qrCodeScanScreen = '/qrCodeScan';
  static const termsConditionsScreen = '/TermsConditions';
  static const myAccountScreen = '/myAccount';
  static const appSettingsNotificationScreen = '/appSettingsNotification';
  static const appSettingsAppearanceScreen = '/appSettingsAppearance';
  static const appSettingsLangCurrScreen = '/appSettingsLangCurr';
  static const appSettingsChangeLogsScreen = '/AppSettingsChangeLogs';
  static const appSettingsSecurityScreen = '/appSettingsSecurity';
  static const landingScreen = '/landingScreen';
  static const confirmPasswordScreen = '/confirmPassword';

  static Route onGenerateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    switch (settings.name) {
      case backupMnemonicScreen:
        return PageRouteBuilder(
          settings: settings,
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
          settings: settings,
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
          settings: settings,
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
          settings: settings,
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
          settings: settings,
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
      case privacyPolicyScreen:
        builder = (_) {
          return PrivacyPolicyScreen();
        };
        break;
      case coinWithdrawScreen:
        builder = (_) {
          return CoinWithdrawScreen();
        };
        break;
      case coinTradeScreen:
        builder = (_) {
          return CoinTradeScreen(
            enumInitalCardFlipState: settings.arguments as EnumCardFlipState,
          );
        };
        break;
      case balanceDepositScreenOne:
        builder = (_) {
          return BalanceDepositScreenOne();
        };
        break;
      case notifDepositScreen:
        builder = (_) {
          return NotifDepositScreen(
              screenType: settings.arguments as EnumDepositScreenTypes);
        };
        break;
      case notifDetailsScreen:
        builder = (_) {
          return NotifDetailsScreen();
        };
        break;
      case balanceCoinPreviewScreen:
        builder = (_) {
          return BalanceCoinPreviewScreen();
        };
        break;
      case marketTokenSelectionScreen:
        return MaterialPageRoute<MarketSelectionResultModel>(
          builder: (_) {
            return MarketTokenSelectionScreen();
          },
          settings: settings,
        );
      case appSettingsHelpScreen:
        builder = (_) {
          return AppSettingsHelpScreen();
        };
        break;
      case balanceSummaryScreen:
        builder = (_) {
          return BalanceSummaryScreen();
        };
        break;
      case qrCodeScanScreen:
        builder = (_) {
          return QRCodeScanScreen();
        };
        break;
      case termsConditionsScreen:
        builder = (_) {
          return TermsConditionsScreen();
        };
        break;
      case myAccountScreen:
        builder = (_) {
          return MyAccountScreen();
        };
        break;
      case appSettingsNotificationScreen:
        builder = (_) {
          return AppSettingsNotificationScreen();
        };
        break;
      case appSettingsAppearanceScreen:
        builder = (_) {
          return AppSettingsAppearance();
        };
        break;
      case appSettingsLangCurrScreen:
        builder = (_) {
          return AppSettingsLangCurrScreen();
        };
        break;
      case appSettingsSecurityScreen:
        builder = (_) {
          return AppSettingsSecurity();
        };
        break;
      case appSettingsChangeLogsScreen:
        builder = (_) {
          return AppSettingsChangeLogsScreen();
        };
        break;
      case landingScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Interval(0.500, 1.00),
                ),
                child: LandingScreen());
          },
        );
      case introScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Interval(0.500, 1.00)),
              child: IntroScreen(),
            );
          },
        );
      case confirmPasswordScreen:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Interval(0.500, 1.00)),
              child: ConfirmPasswordScreen(),
            );
          },
        );
      default:
        builder = (_) {
          return AuthLogoutScreen();
        };
        break;
    }

    return MaterialPageRoute<dynamic>(builder: builder, settings: settings);
  }
}
