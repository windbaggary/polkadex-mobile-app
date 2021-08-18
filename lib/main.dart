import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  List<String>? localeParams =
      (await injection.dependency<FlutterSecureStorage>().read(key: 'language'))
          ?.split('_');

  // A 2 seconds delay to show the splash screen
  await Future.delayed(const Duration(seconds: 2));

  runApp(
    MyApp(
      locale: localeParams != null
          ? Locale(localeParams[0], localeParams.asMap()[1])
          : null,
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({this.locale});

  final Locale? locale;

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? currentLocale;

  @override
  void initState() {
    super.initState();
    currentLocale = widget.locale;
  }

  void setLocale(Locale locale) {
    setState(() {
      currentLocale = widget.locale;
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
      builder: (context, _) => MaterialApp(
        locale: widget.locale,
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
