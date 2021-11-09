import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/landing/presentation/screens/landing_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/intro_screen.dart';
import 'package:polkadex/common/providers/bottom_navigation_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    AppConfigs.size = WidgetsBinding.instance!.window.physicalSize;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavigationProvider>(
            create: (_) => BottomNavigationProvider()),
      ],
      builder: (context, _) => MaterialApp(
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
            return IntroScreen();
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
    );
  }
}
