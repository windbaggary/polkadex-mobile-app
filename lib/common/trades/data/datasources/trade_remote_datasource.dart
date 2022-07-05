import 'dart:convert';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:polkadex/common/network/blockchain_rpc_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';
import 'package:polkadex/graphql/queries.dart';

class TradeRemoteDatasource {
  final _baseUrl = dotenv.env['POLKADEX_HOST_URL']!;

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
      Uri.parse('$_baseUrl/cancel_order'),
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

  Future<QueryResult> fetchOpenOrders(String address) async {
    return await dependency<GraphQLClient>().query(
      QueryOptions(
        document: gql(
            listOpenOrdersByMainAccount), // this is the query string you just created
        variables: {
          'main_account': address,
        },
      ),
    );
  }

  Future<QueryResult> fetchOrders(String address) async {
    return await dependency<GraphQLClient>().query(
      QueryOptions(
        document: gql(
            listOrderHistorybyMainAccount), // this is the query string you just created
        variables: {
          'main_account': address,
          'from': '2010-01-01T00:00:00Z',
          'to': DateTime.now().toUtc().toIso8601String(),
        },
      ),
    );
  }

  Future<QueryResult> fetchTrades(String address) async {
    return await dependency<GraphQLClient>().query(
      QueryOptions(
        document: gql(
            listTransactionsByMainAccount), // this is the query string you just created
        variables: {
          'main_account': address,
          'from': '2010-01-01T00:00:00Z',
          'to': DateTime.now().toUtc().toIso8601String(),
        },
      ),
    );
  }
}
