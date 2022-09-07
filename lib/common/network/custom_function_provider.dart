import 'package:amplify_api/amplify_api.dart';
import 'package:polkadex/common/utils/string_utils.dart';

class CustomFunctionProvider extends FunctionAuthProvider {
  bool useCustomTokenNext = false;
  String customToken = '';

  @override
  Future<String?> getLatestAuthToken() async {
    if (useCustomTokenNext) {
      useCustomTokenNext = false;
      return customToken;
    } else {
      return StringUtils.generateCryptoRandomString();
    }
  }

  Future<void> setToUseCustomTokenNext(String token) async {
    customToken = token;
    useCustomTokenNext = true;
  }
}
