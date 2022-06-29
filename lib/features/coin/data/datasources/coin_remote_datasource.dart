import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CoinRemoteDatasource {
  final _baseUrl = dotenv.get('POLKADEX_HOST_URL');

  Future<Response> withdraw(
    String asset,
    double amount,
    String address,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/withdraw'),
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
