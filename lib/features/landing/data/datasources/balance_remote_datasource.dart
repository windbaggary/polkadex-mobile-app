import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BalanceRemoteDatasource {
  final _baseUrl = dotenv.env['POLKADEX_HOST_URL']!;

  Future<Response> fetchBalance(
    String address,
    String signature,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/fetch_balance'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': signature},
        'payload': {'account': address},
      }),
    );
  }

  Future<Response> testDeposit(
    int asset,
    String address,
    String signature,
  ) async {
    return await post(
      Uri.parse('$_baseUrl/test_deposit'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'signature': {'Sr25519': signature},
        'payload': {
          'account': address,
          'asset': asset,
          'amount': '100.0',
        },
      }),
    );
  }
}
