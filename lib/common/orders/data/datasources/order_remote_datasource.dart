import 'dart:convert';
import 'package:http/http.dart';
import 'package:polkadex/common/network/blockchain_rpc_helper.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';

class OrderRemoteDatasource {
  final _baseUrl = dotenv.env['POLKADEX_HOST_URL']!;

  Future<Response> placeOrder(
    int nonce,
    int baseAsset,
    int quoteAsset,
    String orderType,
    String orderSide,
    String price,
    String amount,
    String address,
    String signature,
  ) async {
    final String _callPlaceOrderJSON =
        "polkadexWorker.placeOrderJSON(keyring.addFromUri('//Bob'), keyring.addFromUri('//Alice').address, 0, '$baseAsset', '$quoteAsset', '$orderType', '$orderSide', $price, $amount)";
    final List<dynamic> payloadResult = await dependency<WebViewRunner>()
        .evalJavascript(_callPlaceOrderJSON, isSynchronous: true);

    BlockchainRpcHelper.sendRpcRequest('enclave_placeOrder', payloadResult);

    return await post(
      Uri.parse('$_baseUrl/place_order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': signature},
        'payload': {
          'account': address,
          'symbol': [baseAsset, quoteAsset],
          'order_type': orderType.toString().split('.')[1].capitalize(),
          'order_side': orderSide.toString().split('.')[1].capitalize(),
          'price': price,
          'amount': amount,
        },
      }),
    );
  }

  Future<Response> cancelOrder(
    int nonce,
    String address,
    int orderUuid,
    String signature,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/cancel_order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': signature},
        'payload': {
          'account': address,
          'order_id': orderUuid,
        },
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

  Future<Response> fetchOrders(
    String address,
    String signature,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/fetch_orders'),
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
