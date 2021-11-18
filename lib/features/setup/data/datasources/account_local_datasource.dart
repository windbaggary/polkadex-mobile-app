import 'dart:convert';
import 'package:biometric_storage/biometric_storage.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';

class AccountLocalDatasource {
  Future<BiometricStorageFile> _getKeypairFile() {
    return BiometricStorage().getStorage('keypair',
        options: StorageFileInitOptions(authenticationRequired: false));
  }

  Future<BiometricStorageFile> _getPasswordFile() {
    return BiometricStorage().getStorage(
      'password',
      promptInfo: PromptInfo(
        androidPromptInfo: AndroidPromptInfo(
          title: 'Authenticate',
          subtitle: 'Confirm wallet secure access with biometric',
        ),
      ),
    );
  }

  Future<void> saveAccountStorage(String keypairJson,
      {String? password}) async {
    final BiometricStorageFile keypairFile = await _getKeypairFile();
    await keypairFile.write(keypairJson);

    if (password != null) {
      final BiometricStorageFile passwordFile =
          await BiometricStorage().getStorage('password');
      await passwordFile.write(password);
    }

    return;
  }

  Future<String?> getAccountStorage() async {
    final BiometricStorageFile keypairFile =
        await BiometricStorage().getStorage(
      'keypair',
      options: StorageFileInitOptions(authenticationRequired: false),
    );

    return await keypairFile.read();
  }

  Future<void> deleteAccountAndPasswordStorage() async {
    final BiometricStorageFile keypairFile =
        await BiometricStorage().getStorage(
      'keypair',
      options: StorageFileInitOptions(authenticationRequired: false),
    );
    final BiometricStorageFile passwordFile =
        await BiometricStorage().getStorage('password');

    await keypairFile.delete();
    await passwordFile.delete();

    return;
  }

  Future<bool> savePasswordStorage(String password) async {
    try {
      final BiometricStorageFile passwordFile = await _getPasswordFile();
      await passwordFile.write(password);
    } on AuthException {
      return false;
    }

    return true;
  }

  Future<String?> getPasswordStorage() async {
    try {
      final BiometricStorageFile passwordFile = await _getPasswordFile();
      return await passwordFile.read();
    } on AuthException {
      return null;
    }
  }

  Future<bool> confirmPassword(
      Map<String, dynamic> account, String password) async {
    final String _callGetKeyPair =
        'keypair = keyring.addFromJson(${json.encode(account)})';
    final String _callUnlockWithPassword =
        'polkadexWorker.confirmAndUnlock(keypair, "$password")';

    await dependency<WebViewRunner>()
        .evalJavascript(_callGetKeyPair, isSynchronous: true);
    final bool result = await dependency<WebViewRunner>()
        .evalJavascript(_callUnlockWithPassword);

    return result;
  }

  Future<Map<String, dynamic>> registerUser(
      Map<String, dynamic> account) async {
    final String _callRegister =
        'polkadexWorker.register(${account['address']}, ${account['address']}})';

    final Map<String, dynamic> result =
        await dependency<WebViewRunner>().evalJavascript(_callRegister);

    return result;
  }
}
