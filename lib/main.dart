import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:polkadex/app_lifecycle_widget.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/providers/bottom_navigation_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/injection_container.dart' as injection;
import 'package:polkadex/generated/l10n.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'common/navigation/coordinator.dart';
import 'common/navigation/routes.dart';
import 'features/landing/presentation/providers/trade_tab_provider.dart';

void main() async {
  // Load the secret keys from .env file
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();
  await injection.init();

  // A 2 seconds delay to show the splash screen
  await Future.delayed(const Duration(seconds: 2));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_MyAppState>()!.restartApp();
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavigationProvider>(
            create: (_) => BottomNavigationProvider()),
        ChangeNotifierProvider<TradeTabViewProvider>(
            create: (context) => TradeTabViewProvider()),
      ],
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider<AccountCubit>(
            create: (_) =>
                injection.dependency<AccountCubit>()..loadAccountData(),
          ),
        ],
        child: AppLifecycleWidget(
          child: KeyedSubtree(
            key: key,
            child: MaterialApp(
              localizationsDelegates: [
                S.delegate,
                LocaleNamesLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              title: 'Polkadex',
              theme: ThemeData(
                  cupertinoOverrideTheme:
                      CupertinoThemeData(brightness: Brightness.dark),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  buttonTheme:
                      ButtonThemeData(buttonColor: AppColors.color1C2023),
                  canvasColor: AppColors.color2E303C,
                  fontFamily: 'WorkSans',
                  dialogTheme: DialogTheme(
                    backgroundColor: AppColors.color2E303C,
                  ),
                  colorScheme: ColorScheme(
                    brightness: Brightness.light,
                    primary: AppColors.color2E303C,
                    onPrimary: AppColors.color2E303C,
                    surface: AppColors.color2E303C,
                    onSurface: AppColors.color2E303C,
                    primaryContainer: AppColors.color2E303C,
                    secondary: Colors.grey,
                    secondaryContainer: Colors.grey,
                    onSecondary: Colors.grey,
                    background: AppColors.color3B4150,
                    onBackground: AppColors.color3B4150,
                    error: Colors.grey,
                    onError: Colors.grey,
                  )).copyWith(
                pageTransitionsTheme: PageTransitionsTheme(
                  builders: {
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                  },
                ),
              ),
              navigatorKey: Coordinator.navigationKey,
              initialRoute: Routes.authLogoutScreen,
              onGenerateRoute: Routes.onGenerateRoute,
              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      ),
    );
  }
}
