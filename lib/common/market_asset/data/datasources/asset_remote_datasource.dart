import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';

class AssetRemoteDatasource {
  Future<List<dynamic>> getAssetsDetails() async {
    final String _callAssetsDetails = "polkadexWorker.getAssetDetails()";

    return await dependency<WebViewRunner>().evalJavascript(_callAssetsDetails);
  }
}
