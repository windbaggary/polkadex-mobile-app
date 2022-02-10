import 'dart:convert';
import 'package:http/http.dart';

class GraphRemoteDatasource {
  Future<Response> getCoinGraphData(
    String leftTokenId,
    String rightTokenId,
    String timestamp,
  ) async {
    return await post(
      Uri.parse('https://ec2-3-101-117-26.us-west-1.polkadex.trade/fetchohlcv'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, dynamic>{
        'symbol': '$leftTokenId-$rightTokenId',
        'timeframe': timestamp,
        'timestamp_start': -1296000
      }),
    );
  }
}
