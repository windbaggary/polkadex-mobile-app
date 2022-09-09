import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:polkadex/common/graph/domain/usecases/get_graph_updates_usecase.dart';
import 'package:polkadex/common/market_asset/data/datasources/market_remote_datasource.dart';
import 'package:polkadex/common/market_asset/data/repositories/asset_repository.dart';
import 'package:polkadex/common/market_asset/data/repositories/market_repository.dart';
import 'package:polkadex/common/market_asset/domain/repositories/iasset_repository.dart';
import 'package:polkadex/common/market_asset/domain/repositories/imarket_repository.dart';
import 'package:polkadex/common/market_asset/domain/usecases/get_assets_details_usecase.dart';
import 'package:polkadex/common/market_asset/domain/usecases/get_markets_usecase.dart';
import 'package:polkadex/common/market_asset/presentation/cubit/market_asset_cubit.dart';
import 'package:polkadex/common/graph/data/repositories/graph_repository.dart';
import 'package:polkadex/common/graph/domain/repositories/igraph_repository.dart';
import 'package:polkadex/common/graph/domain/usecases/get_graph_data_usecase.dart';
import 'package:polkadex/common/network/custom_function_provider.dart';
import 'package:polkadex/common/orderbook/data/datasources/orderbook_remote_datasource.dart';
import 'package:polkadex/common/orderbook/domain/repositories/iorderbook_repository.dart';
import 'package:polkadex/common/orderbook/domain/usecases/get_orderbook_data_usecase.dart';
import 'package:polkadex/common/orderbook/presentation/cubit/orderbook_cubit.dart';
import 'package:polkadex/common/trades/domain/usecases/get_account_trades_updates_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_account_trades_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_updates_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_recent_trades_updates_usecase.dart';
import 'package:polkadex/common/user_data/user_data_remote_datasource.dart';
import 'package:polkadex/features/coin/presentation/cubits/trade_history_cubit/trade_history_cubit.dart';
import 'package:polkadex/features/coin/data/datasources/coin_remote_datasource.dart';
import 'package:polkadex/features/coin/data/repositories/coin_repository.dart';
import 'package:polkadex/features/coin/domain/repositories/icoin_repository.dart';
import 'package:polkadex/common/trades/presentation/cubits/order_history_cubit/order_history_cubit.dart';
import 'package:polkadex/features/landing/data/datasources/balance_remote_datasource.dart';
import 'package:polkadex/common/trades/data/datasources/trade_remote_datasource.dart';
import 'package:polkadex/features/landing/data/datasources/ticker_remote_datasource.dart';
import 'package:polkadex/features/landing/data/repositories/balance_repository.dart';
import 'package:polkadex/common/trades/data/repositories/trade_repository.dart';
import 'package:polkadex/features/landing/data/repositories/ticker_repository.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';
import 'package:polkadex/common/trades/domain/repositories/itrade_repository.dart';
import 'package:polkadex/features/landing/domain/repositories/iticker_repository.dart';
import 'package:polkadex/common/trades/domain/usecases/cancel_order_usecase.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:polkadex/common/cubits/account_cubit/account_cubit.dart';
import 'package:polkadex/features/landing/domain/usecases/get_all_tickers_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_updates_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_ticker_updates_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/ticker_cubit/ticker_cubit.dart';
import 'package:polkadex/features/setup/data/datasources/account_local_datasource.dart';
import 'package:polkadex/features/setup/data/datasources/account_remote_datasource.dart';
import 'package:polkadex/features/setup/data/datasources/address_remote_datasource.dart';
import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';
import 'package:polkadex/features/setup/data/repositories/account_repository.dart';
import 'package:polkadex/features/setup/data/repositories/address_repository.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/repositories/iadress_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_sign_up_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_current_user_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_main_account_address_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/resend_code_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_in_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_out_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/sign_up_usecase.dart';
import 'package:polkadex/features/landing/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/landing/presentation/providers/wallet_settings_provider.dart';
import 'package:polkadex/features/trade/presentation/cubits/coin_graph_cubit.dart';
import 'package:polkadex/common/graph/data/datasources/graph_remote_datasource.dart';
import 'package:polkadex/common/market_asset/data/datasources/asset_remote_datasource.dart';
import 'package:polkadex/common/orderbook/data/repositories/orderbook_repository.dart';
import 'package:polkadex/common/orderbook/domain/usecases/get_orderbook_updates_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_orders_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/get_recent_trades_usecase.dart';
import 'package:polkadex/common/trades/domain/usecases/place_order_usecase.dart';
import 'features/coin/domain/usecases/withdraw_usecase.dart';
import 'features/coin/presentation/cubits/withdraw_cubit/withdraw_cubit.dart';
import 'features/landing/presentation/cubits/recent_trades_cubit/recent_trades_cubit.dart';
import 'features/setup/domain/repositories/imnemonic_repository.dart';
import 'features/setup/domain/usecases/get_password_usecase.dart';
import 'features/setup/domain/usecases/import_trade_account_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/balance_cubit/balance_cubit.dart';
import 'common/web_view_runner/web_view_runner.dart';
import 'package:get_it/get_it.dart';

final dependency = GetIt.instance;

Future<void> init() async {
  final bool isBiometricAvailable =
      (await BiometricStorage().canAuthenticate()) ==
          CanAuthenticateResponse.success;

  dependency.registerLazySingleton(
    () => isBiometricAvailable,
    instanceName: 'isBiometricAvailable',
  );

  dependency.registerSingleton<WebViewRunner>(
    WebViewRunner()..launch(jsCode: 'assets/js/main.js'),
  );

  dependency.registerSingleton<FirebaseAnalytics>(FirebaseAnalytics.instance);

  dependency
      .registerSingleton<CustomFunctionProvider>(CustomFunctionProvider());

  dependency.registerFactory(
    () => MnemonicRemoteDatasource(),
  );

  dependency.registerFactory(
    () => AccountLocalDatasource(),
  );
  dependency.registerFactory(
    () => AccountRemoteDatasource(),
  );

  dependency.registerFactory(
    () => AddressRemoteDatasource(),
  );

  dependency.registerFactory<IMnemonicRepository>(
    () => MnemonicRepository(
      mnemonicRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory<IAccountRepository>(
    () => AccountRepository(
      accountLocalDatasource: dependency(),
      accountRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory<IAdressRepository>(
    () => AddressRepository(
      addressRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GenerateMnemonicUseCase(
      mnemonicRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => ImportTradeAccountUseCase(
      mnemonicRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => SaveAccountUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetAccountUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetMainAccountAddressUsecase(
      addressRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => DeleteAccountUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => DeletePasswordUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => SavePasswordUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetPasswordUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => SignUpUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => ConfirmSignUpUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => SignInUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => SignOutUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetCurrentUserUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => ConfirmPasswordUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => MnemonicProvider(
      generateMnemonicUseCase: dependency(),
      importAccountUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => ResendCodeUseCase(accountRepository: dependency()),
  );

  dependency.registerSingleton<AccountCubit>(
    AccountCubit(
      signUpUseCase: dependency(),
      signInUseCase: dependency(),
      signOutUseCase: dependency(),
      confirmSignUpUseCase: dependency(),
      getCurrentUserUseCase: dependency(),
      resendCodeUseCase: dependency(),
      savePasswordUseCase: dependency(),
      deleteAccountUseCase: dependency(),
      deletePasswordUseCase: dependency(),
      saveAccountUseCase: dependency(),
      importTradeAccountUseCase: dependency(),
      getPasswordUseCase: dependency(),
      getAccountStorageUseCase: dependency(),
      confirmPasswordUseCase: dependency(),
      getMainAccountAddressUsecase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => TradeRemoteDatasource(),
  );

  dependency.registerFactory<ITradeRepository>(
    () => TradeRepository(
      tradeRemoteDatasource: dependency(),
      userDataRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => PlaceOrderUseCase(
      tradeRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => CancelOrderUseCase(
      tradeRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => PlaceOrderCubit(
      placeOrderUseCase: dependency(),
    ),
  );

  dependency.registerFactory(() => WalletSettingsProvider());

  dependency.registerFactory(
    () => GraphRemoteDatasource(),
  );

  dependency.registerFactory<IGraphRepository>(
    () => GraphRepository(
      graphLocalDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetCoinGraphDataUseCase(
      graphRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetGraphUpdatesUseCase(
      graphRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => CoinGraphCubit(
      getGraphDataUseCase: dependency(),
      getGraphUpdatesUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => BalanceRemoteDatasource(),
  );

  dependency.registerFactory<IBalanceRepository>(
    () => BalanceRepository(
      balanceRemoteDatasource: dependency(),
      userDataRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetBalanceUseCase(
      balanceRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetBalanceUpdatesUseCase(
      balanceRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => BalanceCubit(
      getBalanceUseCase: dependency(),
      getBalanceUpdatesUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => CoinRemoteDatasource(),
  );

  dependency.registerFactory<ICoinRepository>(
    () => CoinRepository(
      coinRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => WithdrawUseCase(
      coinRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => WithdrawCubit(
      withdrawUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => OrderbookRemoteDatasource(),
  );

  dependency.registerFactory<IOrderbookRepository>(
    () => OrderbookRepository(
      orderbookRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetOrderbookDataUseCase(
      orderbookRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetOrderbookUpdatesUseCase(
      orderbookRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => OrderbookCubit(
      fetchOrderbookDataUseCase: dependency(),
      fetchOrderbookUpdatesUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetOrdersUseCase(
      tradeRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetOrdersUpdatesUseCase(
      tradeRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetAccountTradesUseCase(
      tradeRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetAccountTradesUpdatesUseCase(
      tradeRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetRecentTradesUseCase(
      tradeRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetRecentTradesUpdatesUseCase(
      tradeRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => RecentTradesCubit(
      getRecentTradesUseCase: dependency(),
      getRecentTradesUpdatesUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => OrderHistoryCubit(
        getOrdersUseCase: dependency(),
        cancelOrderUseCase: dependency(),
        getOrdersUpdatesUseCase: dependency()),
  );

  dependency.registerFactory(
    () => TradeHistoryCubit(
      getTradesUseCase: dependency(),
      getAccountTradesUpdatesUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => TickerRemoteDatasource(),
  );

  dependency.registerSingleton<ITickerRepository>(
    TickerRepository(
      tickerRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetAllTickersUseCase(
      tickerRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetTickerUpdatesUseCase(
      tickerRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => TickerCubit(
      getAllTickersUseCase: dependency(),
      getTickerUpdatesUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => MarketRemoteDatasource(),
  );

  dependency.registerFactory(
    () => AssetRemoteDatasource(),
  );

  dependency.registerFactory<IMarketRepository>(
    () => MarketRepository(marketRemoteDatasource: dependency()),
  );

  dependency.registerFactory<IAssetRepository>(
    () => AssetRepository(assetRemoteDatasource: dependency()),
  );

  dependency.registerFactory(
    () => GetMarketsUseCase(marketRepository: dependency()),
  );

  dependency.registerFactory(
    () => GetAssetsDetailsUseCase(assetRepository: dependency()),
  );

  dependency.registerSingleton<MarketAssetCubit>(
    MarketAssetCubit(
      getMarketsUseCase: dependency(),
      getAssetsDetailsUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => UserDataRemoteDatasource(),
  );
}
