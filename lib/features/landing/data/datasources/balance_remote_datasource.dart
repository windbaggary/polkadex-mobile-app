import 'dart:convert';
import 'package:dart_amqp/dart_amqp.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';
import 'package:polkadex/injection_container.dart';
import 'package:polkadex/common/network/mysql_client.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/common/network/rabbit_mq_client.dart';

class BalanceRemoteDatasource {
  final _baseUrl = dotenv.env['POLKADEX_HOST_URL']!;

  Future<IResultSet> fetchBalance(String address) async {
    final dbClient = dependency<MysqlClient>();

    return await dbClient.getBalanceAssets(address);
  }

  Future<Consumer?> fetchBalanceConsumer() async {
    final Consumer? consumer = await dependency<RabbitMqClient>()
        .tryBindQueueToConsumer(
            '${StringUtils.generateCryptoRandomString()}-balance-update-events',
            '*.balance-update-events');

    return consumer;
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
