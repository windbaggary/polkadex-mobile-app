import 'dart:convert';
import 'package:http/http.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';

class OrderRemoteDatasource {
  final _baseUrl = 'https://ramen-1.polkadex.trade:443/api/';

  Future<Response> placeOrder(
    int nonce,
    String baseAsset,
    String quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    double price,
    double quantity,
    String signature,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/place_order'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': signature},
        'payload': {
          'symbol': [baseAsset, quoteAsset],
          'order_type': orderType.toString().split('.')[1].capitalize(),
          'order_side': orderSide.toString().split('.')[1].capitalize(),
          'price': price,
          'amount': quantity,
        },
      }),
    );
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
