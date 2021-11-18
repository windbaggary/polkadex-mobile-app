import 'package:biometric_storage/biometric_storage.dart';
import 'package:polkadex/common/cubits/account_cubit.dart';
import 'package:polkadex/features/setup/data/datasources/account_local_datasource.dart';
import 'package:polkadex/features/setup/data/datasources/mnemonic_remote_datasource.dart';
import 'package:polkadex/features/setup/data/repositories/account_repository.dart';
import 'package:polkadex/features/setup/data/repositories/mnemonic_repository.dart';
import 'package:polkadex/features/setup/domain/repositories/iaccount_repository.dart';
import 'package:polkadex/features/setup/domain/usecases/confirm_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/delete_account_and_password_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/get_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/register_user_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_account_usecase.dart';
import 'package:polkadex/features/setup/domain/usecases/save_password_usecase.dart';
import 'package:polkadex/features/setup/presentation/providers/mnemonic_provider.dart';
import 'package:polkadex/features/setup/presentation/providers/wallet_settings_provider.dart';
import 'features/setup/domain/repositories/imnemonic_repository.dart';
import 'features/setup/domain/usecases/get_password_usecase.dart';
import 'features/setup/domain/usecases/import_account_usecase.dart';
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
    () => DeleteAccountAndPasswordUseCase(
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
      getAccountStorageUseCase: dependency(),
      deleteAccountAndPasswordUseCase: dependency(),
      savePasswordUseCase: dependency(),
      saveAccountUseCase: dependency(),
      importAccountUseCase: dependency(),
      getPasswordUseCase: dependency(),
      confirmPasswordUseCase: dependency(),
      registerUserUseCase: dependency(),
    ),
  );

  dependency.registerFactory(() => WalletSettingsProvider());
}
