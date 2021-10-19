abstract class IAccountRepository {
  Future<void> saveAccountStorage(String keypairJson, {String? password});
}
