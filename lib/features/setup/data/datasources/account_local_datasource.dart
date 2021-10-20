import 'package:biometric_storage/biometric_storage.dart';

class AccountLocalDatasource {
  Future<void> saveAccountStorage(String keypairJson,
      {String? password}) async {
    final BiometricStorageFile fileKeypair =
        await BiometricStorage().getStorage('keypair');
    await fileKeypair.write(keypairJson);

    if (password != null) {
      final BiometricStorageFile filePassword =
          await BiometricStorage().getStorage(
        'password',
        options: StorageFileInitOptions(authenticationRequired: true),
      );
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
}
