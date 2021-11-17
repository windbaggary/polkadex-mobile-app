import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:polkadex/app_lifecycle_widget.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/landing/screens/landing_screen.dart';
import 'package:polkadex/common/providers/bottom_navigation_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:polkadex/features/setup/presentation/screens/auth_logout_screen.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/injection_container.dart' as injection;
import 'package:polkadex/generated/l10n.dart';

void main() async {
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
    AppConfigs.size = WidgetsBinding.instance!.window.physicalSize;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavigationProvider>(
            create: (_) => BottomNavigationProvider()),
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
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  buttonTheme: ButtonThemeData(buttonColor: color1C2023),
                  canvasColor: color2E303C,
                  fontFamily: 'WorkSans',
                  dialogTheme: DialogTheme(
                    backgroundColor: color2E303C,
                  ),
                  colorScheme: ColorScheme(
                    brightness: Brightness.light,
                    primary: color2E303C,
                    onPrimary: color2E303C,
                    surface: color2E303C,
                    onSurface: color2E303C,
                    primaryVariant: color2E303C,
                    secondary: Colors.grey,
                    secondaryVariant: Colors.grey,
                    onSecondary: Colors.grey,
                    background: color3B4150,
                    onBackground: color3B4150,
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

              // Set the initial route
              home: Builder(
                builder: (context) {
                  AppConfigs.size = MediaQuery.of(context).size;
                  return AuthLogoutScreen();
                },
              ),
              onGenerateRoute: (settings) {
                late Widget screen;
                switch (settings.name) {
                  case LandingScreen.routeName:
                    screen = LandingScreen();
                    break;
                }

                return MaterialPageRoute(
                    builder: (context) => screen, settings: settings);
              },

              debugShowCheckedModeBanner: false,
            ),
          ),
        ),
      ),
    );
  }
}
