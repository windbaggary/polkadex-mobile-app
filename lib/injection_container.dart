import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/providers/wallet_settings_provider.dart';

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
    () => MnemonicProvider(
      generateMnemonicUseCase: dependency(),
    ),
  );

  dependency.registerFactory(() => WalletSettingsProvider());
}
