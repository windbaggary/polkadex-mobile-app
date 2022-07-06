import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:polkadex/common/network/blockchain_rpc_helper.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';
import 'package:polkadex/graphql/queries.dart';

class TradeRemoteDatasource {
  Future<String?> placeOrder(
    String mainAddress,
    String proxyAddress,
    String baseAsset,
    String quoteAsset,
    String orderType,
    String orderSide,
    String price,
    String amount,
  ) async {
    try {
      final nonce = await BlockchainRpcHelper.sendRpcRequest(
          'enclave_getNonce', [mainAddress]);

      final String _callPlaceOrderJSON =
          "polkadexWorker.placeOrderJSON(keyring.getPair('$proxyAddress'), ${nonce + 1}, '$baseAsset', '$quoteAsset', '$orderType', '$orderSide', $price, $amount)";
      final List<dynamic> payloadResult = await dependency<WebViewRunner>()
          .evalJavascript(_callPlaceOrderJSON, isSynchronous: true);

      return (await BlockchainRpcHelper.sendRpcRequest(
          'enclave_placeOrder', payloadResult)) as String?;
    } catch (e) {
      return null;
    }
  }

  Future<http.Response> cancelOrder(
    int nonce,
    String address,
    int orderUuid,
  ) async {
    return await http.post(
      Uri.parse('/cancel_order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': ''},
        'payload': {
          'account': address,
          'order_id': orderUuid,
        },
      }),
    );
  }

  Future<GraphQLResponse> fetchOpenOrders(String address) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: listOpenOrdersByMainAccount,
            variables: {
              'main_account': address,
            },
          ),
        )
        .response;
  }

  Future<GraphQLResponse> fetchOrders(String address) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: listOrderHistorybyMainAccount,
            variables: {
              'main_account': address,
              'from': '1970-01-01T00:00:00Z',
              'to': DateTime.now().toUtc().toIso8601String(),
            },
          ),
        )
        .response;
  }

  Future<GraphQLResponse> fetchTrades(String address) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: listTransactionsByMainAccount,
            variables: {
              'main_account': address,
              'from': '1970-01-01T00:00:00Z',
              'to': DateTime.now().toUtc().toIso8601String(),
            },
          ),
        )
        .response;
  }
}
