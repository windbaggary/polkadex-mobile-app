import 'package:polkadex/features/setup/data/datasources/account_local_datasource.dart';
import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';
import 'package:polkadex/features/setup/data/repositories/account_repository.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_storage_usecase.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/providers/wallet_settings_provider.dart';
import 'features/setup/domain/repositories/imnemonic_repository.dart';
import 'features/setup/domain/usecases/import_account_usecase.dart';
import 'common/web_view_runner/web_view_runner.dart';
import 'package:get_it/get_it.dart';

final dependency = GetIt.instance;

Future<void> init() async {
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
    () => SaveAccountStorageUseCase(
      accountRepository: dependency(),
    ),
  );

  dependency.registerFactory(
    () => MnemonicProvider(
      generateMnemonicUseCase: dependency(),
      importAccountUseCase: dependency(),
      saveAccountStorageUseCase: dependency(),
    ),
  );

  dependency.registerFactory(() => WalletSettingsProvider());
}
