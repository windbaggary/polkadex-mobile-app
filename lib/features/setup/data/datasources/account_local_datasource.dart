import 'package:biometric_storage/biometric_storage.dart';

class AccountLocalDatasource {
  Future<void> saveAccountStorage(String keypairJson,
      {String? password}) async {
    final BiometricStorageFile fileKeypair = await BiometricStorage()
        .getStorage('keypair',
            options: StorageFileInitOptions(authenticationRequired: false));
    await fileKeypair.write(keypairJson);

    if (password != null) {
      final BiometricStorageFile filePassword =
          await BiometricStorage().getStorage('password');
      await filePassword.write(password);
    }

    return;
  }

  Future<String?> getAccountStorage() async {
    final BiometricStorageFile fileKeypair =
        await BiometricStorage().getStorage(
      'keypair',
      options: StorageFileInitOptions(authenticationRequired: false),
    );

    return await fileKeypair.read();
  }

  Future<void> deleteAccountAndPasswordStorage() async {
    final BiometricStorageFile fileKeypair =
        await BiometricStorage().getStorage(
      'keypair',
      options: StorageFileInitOptions(authenticationRequired: false),
    );
    final BiometricStorageFile filePassword =
        await BiometricStorage().getStorage('password');

    await fileKeypair.delete();
    await filePassword.delete();

    return;
  }

  Future<bool> savePasswordStorage(String password) async {
    try {
      final BiometricStorageFile filePassword =
          await BiometricStorage().getStorage(
        'password',
        promptInfo: PromptInfo(
          androidPromptInfo: AndroidPromptInfo(
            title: 'Authenticate',
            subtitle: 'Confirm wallet secure access with biometric',
          ),
        ),
      );
      await filePassword.write(password);
    } on AuthException {
      return false;
    }

    return true;
  }
}
