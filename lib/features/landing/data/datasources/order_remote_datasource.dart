import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';

class OrderRemoteDatasource {
  Future<Map<String, dynamic>> placeOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    double price,
    double quantity,
  ) async {
    final String _callPlaceOrder =
        'polkadexWorkerMock.placeOrder(keyring.addFromUri(\'//Bob\'), keyring.addFromUri(\'//Alice\').address, "$nonce", "$baseAsset", "$quoteAsset", "${orderType.toString().toUpperCase().split('.')[1]}", "${orderSide.toString().toUpperCase().split('.')[1]}", "$price", "$quantity")';

    final Map<String, dynamic> result =
        await dependency<WebViewRunner>().evalJavascript(
      _callPlaceOrder,
    );

    return result;
  }
}
