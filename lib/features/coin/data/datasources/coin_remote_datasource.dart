import 'dart:convert';
import 'package:http/http.dart';

class CoinRemoteDatasource {
  final _baseUrl = 'https://ramen-1.polkadex.trade:443/api/';

  Future<Response> withdraw(
    String asset,
    double amount,
    String address,
    String signature,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/withdraw'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': signature},
        'payload': {
          'symbol': asset,
          'amount': amount,
          'address': address,
        },
      }),
    );
  }
}
