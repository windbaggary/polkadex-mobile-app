import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:polkadex/injection_container.dart';
import 'package:polkadex/common/network/mysql_client.dart';

class BalanceRemoteDatasource {
  final _baseUrl = dotenv.env['POLKADEX_HOST_URL']!;

  Future<List<Map<String, dynamic>>?> fetchBalance(String address) async {
    try {
      final dbClient = dependency<MysqlClient>();
      final mainAddress = await dbClient.getMainAddress(address);

      final dbBalanceResult = await dbClient.conn.execute(
          "select free_balance,reserved_balance,asset_type from assets where main_acc = :main_account_id",
          {
            "main_account_id": mainAddress,
          });

      return dbBalanceResult.rows.map((row) => row.assoc()).toList();
    } catch (e) {
      print(e);
      return null;
    }
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
