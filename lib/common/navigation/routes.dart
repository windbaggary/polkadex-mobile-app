import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polkadex/common/market_asset/domain/entities/asset_entity.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
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
import 'package:polkadex/features/coin/presentation/screens/balance_coin_screen.dart';
import 'package:polkadex/features/coin/presentation/screens/balance_deposit_screen_1.dart';
import 'package:polkadex/features/coin/presentation/screens/balance_summary_screen.dart';
import 'package:polkadex/features/coin/presentation/screens/coin_withdraw_screen.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'package:polkadex/features/landing/presentation/screens/landing_screen.dart';
import 'package:polkadex/features/landing/presentation/screens/market_token_selection_screen.dart';
import 'package:polkadex/features/notifications/screens/notif_deposit_screen.dart';
import 'package:polkadex/features/notifications/screens/notif_details_screen.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/providers/wallet_settings_provider.dart';
import 'package:polkadex/features/setup/presentation/screens/auth_logout_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/backup_mnemonic_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/code_verification_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/confirm_password_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/import_wallet_methods_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/intro_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/mnemonic_generated_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/restore_existing_wallet_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/sign_in_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/sign_up_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/wallet_settings_screen.dart';
import 'package:polkadex/features/trade/presentation/screens/coin_trade_screen.dart';
import 'package:polkadex/features/trade/presentation/widgets/card_flip_widgett.dart';
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
  static const signUpScreen = '/signUpScreen';
  static const signInScreen = '/signInScreen';
  static const codeVerificationScreen = '/codeVerificationScreen';
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
                  return RestoreExistingWalletScreen(
                    mnemonicLenght:
                        context.read<MnemonicProvider>().mnemonicWords.length,
                  );
                },
              ),
            );
          },
        );
      case walletSettingsScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return ChangeNotifierProvider(
              create: (context) => dependency<WalletSettingsProvider>(),
              child: ChangeNotifierProvider.value(
                value: settings.arguments as MnemonicProvider,
                child: FadeTransition(
                  opacity: CurvedAnimation(
                      parent: animation, curve: Interval(0.500, 1.00)),
                  child: WalletSettingsScreen(),
                ),
              ),
            );
          },
        );
      case signUpScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Interval(0.500, 1.00)),
              child: SignUpScreen(),
            );
          },
        );
      case signInScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return ChangeNotifierProvider(
              create: (context) => dependency<WalletSettingsProvider>(),
              child: FadeTransition(
                opacity: CurvedAnimation(
                    parent: animation, curve: Interval(0.500, 1.00)),
                child: SignInScreen(),
              ),
            );
          },
        );
      case codeVerificationScreen:
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: CurvedAnimation(
                  parent: animation, curve: Interval(0.500, 1.00)),
              child: CodeVerificationScreen(),
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
          final withdrawArguments = settings.arguments as Map;

          return BlocProvider.value(
            value: withdrawArguments['balanceCubit'] as BalanceCubit,
            child: CoinWithdrawScreen(
              asset: withdrawArguments['asset'],
            ),
          );
        };
        break;
      case coinTradeScreen:
        builder = (_) {
          final coinTradeArguments = settings.arguments as Map;

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                  value: coinTradeArguments['balanceCubit'] as BalanceCubit),
            ],
            child: CoinTradeScreen(
              enumInitalCardFlipState:
                  coinTradeArguments['enumCardFlipState'] as EnumCardFlipState,
              leftToken: coinTradeArguments['baseToken'] as AssetEntity,
              rightToken: coinTradeArguments['quoteToken'] as AssetEntity,
            ),
          );
        };
        break;
      case balanceDepositScreenOne:
        builder = (_) {
          final balanceDepositArguments = settings.arguments as Map;

          return BlocProvider.value(
            value: balanceDepositArguments['balanceCubit'] as BalanceCubit,
            child: BalanceDepositScreenOne(
              tokenId: balanceDepositArguments['tokenId'] as String,
            ),
          );
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
          final balanceCoinArguments = settings.arguments as Map;

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                  value: balanceCoinArguments['balanceCubit'] as BalanceCubit),
            ],
            child: BalanceCoinScreen(
              asset: balanceCoinArguments['asset'] as AssetEntity,
            ),
          );
        };
        break;
      case marketTokenSelectionScreen:
        return MaterialPageRoute<MarketSelectionResultModel>(
          builder: (_) {
            final marketTokenSelectionArguments = settings.arguments as Map;

            return BlocProvider.value(
              value: marketTokenSelectionArguments['orderbookCubit']
                  as OrderbookCubit,
              child: MarketTokenSelectionScreen(),
            );
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
        return MaterialPageRoute<String>(
          builder: (_) {
            final qRCodeScanArguments = settings.arguments as Map;

            return QRCodeScanScreen(
              qRCodeScanArguments['onQrCodeScan'] as Function(String)?,
            );
          },
          settings: settings,
        );
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
              child: LandingScreen(),
            );
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
          settings: settings,
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
