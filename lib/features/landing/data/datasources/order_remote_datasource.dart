import 'dart:convert';
import 'package:http/http.dart';
import 'package:polkadex/common/utils/enums.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderRemoteDatasource {
  final _baseUrl = dotenv.env['POLKADEX_HOST_URL']!;

  Future<Response> placeOrder(
    int nonce,
    int baseAsset,
    int quoteAsset,
    EnumOrderTypes orderType,
    EnumBuySell orderSide,
    double price,
    double quantity,
    String address,
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
          'account': address,
          'symbol': [baseAsset, quoteAsset],
          'order_type': orderType.toString().split('.')[1].capitalize(),
          'order_side': orderSide.toString().split('.')[1].capitalize(),
          'price': price.toString(),
          'amount': quantity.toString(),
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
