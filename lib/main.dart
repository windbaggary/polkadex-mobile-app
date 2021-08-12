import 'dart:io';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:polkadex/common/configs/app_config.dart';
import 'package:polkadex/features/landing/screens/landing_screen.dart';
import 'package:polkadex/features/setup/presentation/screens/intro_screen.dart';
import 'package:polkadex/common/providers/bottom_navigation_provider.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/injection_container.dart' as injection;
import 'package:polkadex/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await injection.init();
  await CountryCodes.init(
    S.delegate.supportedLocales.firstWhere(
      (locale) => locale.countryCode == Platform.localeName.split('_')[1],
      orElse: () => Locale('en', 'US'),
    ),
  );

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
          // 1
          S.delegate,
          // 2
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
            buttonColor: Colors.transparent,
            primaryColor: color2E303C,
            canvasColor: color2E303C,
            fontFamily: 'WorkSans',
            accentColor: colorE6007A,
            backgroundColor: color3B4150,
            dialogTheme: DialogTheme(
              backgroundColor: color2E303C,
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
