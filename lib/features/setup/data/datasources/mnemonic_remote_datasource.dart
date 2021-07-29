import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';

class MnemonicRemoteDatasource {
  Future<Map<String, dynamic>> generateMnemonic() async {
    final String _callGenerateMnemonic = 'keyring.gen()';

    final Map<String, dynamic> result =
        await dependency<WebViewRunner>().evalJavascript(_callGenerateMnemonic);

    return result;
  }

  Future<Map<String, dynamic>> importAccount(
      String mnemonic, String password) async {
    final String _callImportAccount =
        'keyring.recover("mnemonic", "sr25519", \'$mnemonic\', "$password")';

    final Map<String, dynamic> result =
        await dependency<WebViewRunner>().evalJavascript(_callImportAccount);

    return result;
  }
}
