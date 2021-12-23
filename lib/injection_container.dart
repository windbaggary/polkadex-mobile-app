import 'package:polkadex/common/graph/data/repositories/graph_repository.dart';
import 'package:polkadex/common/graph/domain/repositories/igraph_repository.dart';
import 'package:polkadex/common/graph/domain/usecases/get_graph_data_usecase.dart';
import 'package:polkadex/features/coin/data/datasources/coin_remote_datasource.dart';
import 'package:polkadex/features/coin/data/repositories/coin_repository.dart';
import 'package:polkadex/features/coin/domain/repositories/icoin_repository.dart';
import 'package:polkadex/features/landing/data/datasources/balance_remote_datasource.dart';
import 'package:polkadex/features/landing/data/datasources/order_remote_datasource.dart';
import 'package:polkadex/features/landing/data/repositories/balance_repository.dart';
import 'package:polkadex/features/landing/data/repositories/order_repository.dart';
import 'package:polkadex/features/landing/domain/repositories/ibalance_repository.dart';
import 'package:polkadex/features/landing/domain/repositories/iorder_repository.dart';
import 'package:polkadex/features/landing/domain/usecases/cancel_order_usecase.dart';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/features/landing/domain/usecases/get_balance_usecase.dart';
import 'package:polkadex/features/landing/domain/usecases/get_open_orders.dart';
import 'package:polkadex/features/landing/domain/usecases/place_order_usecase.dart';
import 'package:polkadex/features/landing/presentation/cubits/place_order_cubit/place_order_cubit.dart';
import 'package:polkadex/features/landing/presentation/cubits/list_orders_cubit/list_orders_cubit.dart';
import 'package:polkadex/features/setup/data/datasources/account_local_datasource.dart';
import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';
import 'package:polkadex/features/setup/data/repositories/account_repository.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/register_user_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/providers/wallet_settings_provider.dart';
import 'package:polkadex/features/trade/presentation/cubits/coin_graph_cubit.dart';
import 'common/graph/data/datasources/graph_remote_datasource.dart';
import 'features/coin/domain/usecases/withdraw_usecase.dart';
import 'features/coin/presentation/cubits/withdraw_cubit.dart';
import 'features/setup/data/datasources/account_local_datasource.dart';
import 'common/cubits/account_cubit.dart';
import 'features/setup/domain/repositories/imnemonic_repository.dart';
import 'features/setup/domain/usecases/get_password_usecase.dart';
import 'features/setup/domain/usecases/import_account_usecase.dart';
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

  dependency.registerFactory(
    () => MnemonicRemoteDatasource(),
  );

  dependency.registerFactory(
    () => AccountLocalDatasource(),
  );

  dependency.registerFactory<IMnemonicRepository>(
    () => MnemonicRepository(
      mnemonicRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory<IAccountRepository>(
    () => AccountRepository(
      accountLocalDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GenerateMnemonicUseCase(
      mnemonicRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => ImportAccountUseCase(
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
    () => ConfirmPasswordUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => RegisterUserUseCase(
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
    () => AccountCubit(
      savePasswordUseCase: dependency(),
      deleteAccountUseCase: dependency(),
      deletePasswordUseCase: dependency(),
      saveAccountUseCase: dependency(),
      importAccountUseCase: dependency(),
      getPasswordUseCase: dependency(),
      getAccountStorageUseCase: dependency(),
      confirmPasswordUseCase: dependency(),
      registerUserUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => OrderRemoteDatasource(),
  );

  dependency.registerFactory<IOrderRepository>(
    () => OrderRepository(
      orderRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => PlaceOrderUseCase(
      orderRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => CancelOrderUseCase(
      orderRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => PlaceOrderCubit(
      placeOrderUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => ListOrdersCubit(
      cancelOrderUseCase: dependency(),
      getOpenOrdersUseCase: dependency(),
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
    () => CoinGraphCubit(
      getGraphDataUseCase: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetOpenOrdersUseCase(
      orderRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => BalanceRemoteDatasource(),
  );

  dependency.registerFactory<IBalanceRepository>(
    () => BalanceRepository(
      balanceRemoteDatasource: dependency(),
    ),
  );

  dependency.registerFactory(
    () => GetBalanceUseCase(
      balanceRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => BalanceCubit(
      getBalanceUseCase: dependency(),
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
}
