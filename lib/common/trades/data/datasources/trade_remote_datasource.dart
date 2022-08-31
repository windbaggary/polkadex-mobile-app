import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/graphql/subscriptions.dart';
import 'package:polkadex/injection_container.dart';
import 'package:polkadex/graphql/mutations.dart' as mutations;
import 'package:polkadex/graphql/queries.dart';

class TradeRemoteDatasource {
  Future<GraphQLResponse> placeOrder(
    String mainAddress,
    String proxyAddress,
    String baseAsset,
    String quoteAsset,
    String orderType,
    String orderSide,
    String price,
    String amount,
  ) async {
    final String _callPlaceOrderJSON =
        "polkadexWorker.placeOrderJSON(keyring.getPair('$proxyAddress'), '$baseAsset', '$quoteAsset', '$orderType', '$orderSide', $price, $amount)";
    final List<dynamic> payloadResult = await dependency<WebViewRunner>()
        .evalJavascript(_callPlaceOrderJSON, isSynchronous: true);

    return await Amplify.API
        .mutate(
          request: GraphQLRequest(
            document: mutations.placeOrder,
            variables: {
              'input': {
                'payload': json.encode({'PlaceOrder': payloadResult}),
              },
            },
          ),
        )
        .response;
  }

  Future<GraphQLResponse> cancelOrder(
    String address,
    String baseAsset,
    String quoteAsset,
    String orderId,
  ) async {
    final String _callCancelOrderJSON =
        "polkadexWorker.cancelOrderJSON(keyring.getPair('$address'), '$baseAsset', '$quoteAsset', '$orderId')";

    final Map<String, dynamic> payloadResult = await dependency<WebViewRunner>()
        .evalJavascript(_callCancelOrderJSON, isSynchronous: true);

    return await Amplify.API
        .mutate(
          request: GraphQLRequest(
            document: mutations.cancelOrder,
            variables: {
              'input': {
                'payload': json.encode({'CancelOrder': payloadResult}),
              },
            },
          ),
        )
        .response;
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

  Future<GraphQLResponse> fetchOrders(
    String address,
    DateTime from,
    DateTime to,
  ) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: listOrderHistorybyMainAccount,
            variables: {
              'main_account': address,
              'from': from.toUtc().toIso8601String(),
              'to': to.toUtc().toIso8601String(),
            },
          ),
        )
        .response;
  }

  Future<GraphQLResponse> fetchRecentTrades(String market) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: getRecentTrades,
            variables: {
              'm': market,
            },
          ),
        )
        .response;
  }

  Future<GraphQLResponse> fetchAccountTrades(
    String address,
    DateTime from,
    DateTime to,
  ) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: listTransactionsByMainAccount,
            variables: {
              'main_account': address,
              'from': from.toUtc().toIso8601String(),
              'to': to.toUtc().toIso8601String(),
            },
          ),
        )
        .response;
  }

  Future<Stream> getRecentTradesStream(String market) async {
    return Amplify.API.subscribe(
      GraphQLRequest(
        document: websocketStreams,
        variables: <String, dynamic>{
          'name': '$market-recent-trades',
        },
      ),
      onEstablished: () => print('recent trades subscription established'),
    );
  }
}
