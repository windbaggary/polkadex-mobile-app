import 'dart:convert';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/network/custom_function_provider.dart';
import 'package:polkadex/common/providers/bottom_navigation_provider.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/common/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:polkadex/injection_container.dart' as injection;
import 'package:polkadex/generated/l10n.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'amplifyconfiguration.dart';
import 'common/navigation/coordinator.dart';
import 'common/navigation/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:polkadex/features/landing/presentation/cubits/recent_trades_cubit/recent_trades_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'firebase_options.dart';

void main() async {
  // Load the secret keys from .env file
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await injection.init();

  await injection.dependency<WebViewRunner>().subscribeMessage(
    'log',
    (data) async {
      if (data == 'polkadexWorker ready') {
        await injection.dependency<AccountCubit>().loadAccount();
        injection.dependency<MarketAssetCubit>().getMarkets();
      }
    },
  );

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
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    final api = AmplifyAPI(
      authProviders: [
        injection.dependency<CustomFunctionProvider>(),
      ],
    );
    final auth = AmplifyAuthCognito();

    await Amplify.addPlugins([api, auth]);

    final amplifyConfigMap = jsonDecode(amplifyconfig);

    //API access configuration
    amplifyConfigMap['api']['plugins']['awsAPIPlugin']
        [dotenv.get('API_NAME')] = {
      "endpointType": 'GraphQL',
      "endpoint": dotenv.get('GRAPHQL_ENDPOINT'),
      "region": dotenv.get('REGION'),
      "authorizationType": 'AWS_LAMBDA',
    };

    //Auth configuration
    amplifyConfigMap['auth']['plugins']['awsCognitoAuthPlugin'] = {
      "IdentityManager": {"Default": {}},
      "CredentialsProvider": {
        "CognitoIdentity": {
          "Default": {
            "PoolId": dotenv.get('IDENTITY_POOL_ID'),
            "Region": dotenv.get('REGION')
          }
        }
      },
      "CognitoUserPool": {
        "Default": {
          "PoolId": dotenv.get('USER_POOL_ID'),
          "AppClientId": dotenv.get('CLIENT_POOL_ID'),
          "Region": dotenv.get('REGION')
        }
      },
    };

    try {
      await Amplify.configure(jsonEncode(amplifyConfigMap));
    } on AmplifyAlreadyConfiguredException {
      print(
          'Tried to reconfigure Amplify; this can occur when your app restarts on Android.');
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomNavigationProvider>(
            create: (_) => BottomNavigationProvider()),
      ],
      builder: (context, _) => MultiBlocProvider(
        providers: [
          BlocProvider<AccountCubit>(
            create: (_) => injection.dependency<AccountCubit>(),
          ),
          BlocProvider<MarketAssetCubit>(
            create: (_) => injection.dependency<MarketAssetCubit>(),
          ),
          BlocProvider<TickerCubit>(
            create: (_) => injection.dependency<TickerCubit>()..getAllTickers(),
          ),
          BlocProvider<RecentTradesCubit>(
              create: (_) => injection.dependency<RecentTradesCubit>()),
        ],
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
              buttonTheme: ButtonThemeData(buttonColor: AppColors.color1C2023),
              textTheme: Theme.of(context).textTheme.apply(
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
              textSelectionTheme: TextSelectionThemeData(
                cursorColor: AppColors.colorE6007A,
                selectionColor: AppColors.color8E8E93,
                selectionHandleColor: AppColors.colorE6007A,
              ),
              canvasColor: Colors.white,
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
    );
  }
}
