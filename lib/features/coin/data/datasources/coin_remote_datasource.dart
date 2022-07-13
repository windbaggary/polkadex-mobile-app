import 'dart:convert';
import 'package:http/http.dart';

class CoinRemoteDatasource {
  Future<Response> withdraw(
    String asset,
    double amount,
    String address,
  ) async {
    return await post(
      Uri.parse('/withdraw'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': ''},
        'payload': {
          'symbol': asset,
          'amount': amount,
          'address': address,
        },
      }),
    );
  }
}
