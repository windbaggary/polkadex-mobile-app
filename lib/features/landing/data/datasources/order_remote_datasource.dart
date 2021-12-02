import 'dart:convert';

import 'package:http/http.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';

class OrderRemoteDatasource {
  final _baseUrl = 'http://148.251.1.248:7777';

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

  Future<Response> cancelOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    String orderUuid,
    String signature,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/cancel_order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': signature},
        'payload': {'order_id': orderUuid},
      }),
    );
  }

  Future<Response> fetchOpenOrders(
    String address,
    String signature,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/fetch_open_orders'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': signature},
        'payload': {'account': address},
      }),
    );
  }
}
