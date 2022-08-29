import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';

class MnemonicRemoteDatasource {
  Future<Map<String, dynamic>> generateMnemonic() async {
    final String _callGenerateMnemonic = 'polkadexWorker.generateMnemonic()';

    final Map<String, dynamic> result =
        await dependency<WebViewRunner>().evalJavascript(
      _callGenerateMnemonic,
      isSynchronous: true,
    );

    return result;
  }

  Future<Map<String, dynamic>> importTradeAccount(
      String mnemonic, String password) async {
    final String _callImportAccount =
        'polkadexWorker.importAccountFromMnemonic("$mnemonic", "sr25519", "$password")';

    final Map<String, dynamic> result =
        await dependency<WebViewRunner>().evalJavascript(_callImportAccount);

    return result;
  }
}
