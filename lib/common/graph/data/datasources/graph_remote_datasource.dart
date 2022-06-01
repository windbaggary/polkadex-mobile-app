import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GraphRemoteDatasource {
  Future<Response> getCoinGraphData(
    String leftTokenId,
    String rightTokenId,
    String timestamp,
  ) async {
    return await post(
      Uri.parse('${dotenv.get('INFLUX_DB_URL')}/api/fetchohlcv'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'symbol': '$leftTokenId/$rightTokenId',
        'timeframe': timestamp,
        'timestamp_start': -1296000
      }),
    );
  }
}
