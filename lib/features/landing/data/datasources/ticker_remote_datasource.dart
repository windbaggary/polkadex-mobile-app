import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TickerRemoteDatasource {
  Future<Response> getLastTickerData(
    String leftTokenId,
    String rightTokenId,
  ) async {
    return await post(
      Uri.parse('${dotenv.get('INFLUX_DB_URL')}/api/fetch_ticker'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'symbol': '$leftTokenId-$rightTokenId',
      }),
    );
  }
}
