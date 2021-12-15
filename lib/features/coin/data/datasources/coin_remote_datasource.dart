import 'dart:convert';
import 'package:http/http.dart';

class CoinRemoteDatasource {
  final _baseUrl = 'http://148.251.1.248:7777';

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
