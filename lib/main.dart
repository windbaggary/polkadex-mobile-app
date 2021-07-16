import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:polkadex/configs/app_config.dart';
import 'package:polkadex/features/landing/screens/landing_screen.dart';
import 'package:polkadex/features/setup/screens/intro_screen.dart';
import 'package:polkadex/providers/bottom_navigation_provider.dart';
import 'package:polkadex/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        title: 'Polkadex',
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          buttonColor: Colors.transparent,
          primarySwatch: Colors.blue,
          canvasColor: color2E303C,
          fontFamily: 'WorkSans',
        ).copyWith(
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
