import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';

class MarketRemoteDatasource {
  Future<List<Map<String, dynamic>>?> getMarkets() async {
    try {
      final String _callGetMarkets = "polkadexWorker.getMarkets()";

      return await dependency<WebViewRunner>().evalJavascript(_callGetMarkets);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
