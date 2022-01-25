import 'dart:convert';
import 'package:http/http.dart';

class BalanceRemoteDatasource {
  final _baseUrl = 'https://ramen-1.polkadex.trade:443/api/';

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
        'payload': {
          'account': '5HGabetgTWWsoRJxdZP11ns2yi1oVaenXEBprfKHp7tpw7NH'
        },
      }),
    );
  }
}
