import 'dart:convert';
import 'package:http/http.dart';
import 'package:polkadex/common/network/blockchain_rpc_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';
import 'package:polkadex/common/network/mysql_client.dart';

class OrderRemoteDatasource {
  final _baseUrl = dotenv.env['POLKADEX_HOST_URL']!;

  Future<double?> placeOrder(
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
    try {
      final dbClient = dependency<MysqlClient>();
      await dbClient.init();

      final dbProxyResult = await dbClient.conn
          .execute("select * from proxies where proxy = :proxyAddress", {
        "proxyAddress": address,
      });
      final dbAccId = dbProxyResult.rows.first.colByName('id');

      final dbMainResult = await dbClient.conn
          .execute("select * from accounts where id = :acc_id", {
        "acc_id": dbAccId,
      });
      final dbMainAddress = dbMainResult.rows.first.colByName('main_acc');

      final nonce = await BlockchainRpcHelper.sendRpcRequest(
          'enclave_getNonce', [dbMainAddress]);

      final String _callPlaceOrderJSON =
          "polkadexWorker.placeOrderJSON(keyring.getPair('$address'), ${nonce + 1}, '$baseAsset', '$quoteAsset', '$orderType', '$orderSide', $price, $amount)";
      final List<dynamic> payloadResult = await dependency<WebViewRunner>()
          .evalJavascript(_callPlaceOrderJSON, isSynchronous: true);

      return (BlockchainRpcHelper.sendRpcRequest(
          'enclave_placeOrder', payloadResult) as double?);
    } catch (e) {
      print(e);
      return null;
    }
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
