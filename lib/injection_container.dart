import 'package:polkadex/features/landing/data/datasources/order_remote_datasource.dart';
import 'package:polkadex/features/landing/data/repositories/order_repository.dart';
import 'package:polkadex/features/landing/domain/repositories/iorder_repository.dart';
import 'package:polkadex/features/landing/domain/usecases/place_order_usecase.dart';
import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/providers/wallet_settings_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'features/setup/domain/repositories/imnemonic_repository.dart';
import 'features/setup/domain/usecases/import_account_usecase.dart';
import 'common/web_view_runner/web_view_runner.dart';
import 'package:get_it/get_it.dart';

final dependency = GetIt.instance;

Future<void> init() async {
  dependency.registerSingleton<WebViewRunner>(
    WebViewRunner()..launch(jsCode: 'assets/js/main.js'),
  );

  dependency.registerSingleton<FlutterSecureStorage>(
    FlutterSecureStorage(),
  );

  dependency.registerFactory(
    () => MnemonicRemoteDatasource(),
  );

  dependency.registerFactory<IMnemonicRepository>(
    () => MnemonicRepository(
      mnemonicRemoteDatasource: dependency(),
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
    () => MnemonicProvider(
      generateMnemonicUseCase: dependency(),
      importAccountUseCase: dependency(),
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

  dependency.registerFactory(() => WalletSettingsProvider());
}
