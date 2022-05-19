import 'package:dart_amqp/dart_amqp.dart';
import 'package:http/http.dart';
import 'package:polkadex/common/network/rabbit_mq_client.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/injection_container.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class OrderbookRemoteDatasource {
  final _baseUrl = dotenv.get('POLKADEX_HOST_URL');

  Future<Response> getOrderbookData(
    String leftTokenId,
    String rightTokenId,
  ) async {
    return await get(
      Uri.parse('$_baseUrl/fetch_orderbook'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );
  }

  Future<Consumer?> getOrderbookConsumer(
    String leftTokenId,
    String rightTokenId,
  ) async {
    final Consumer? consumer = await dependency<RabbitMqClient>()
        .tryBindQueueToConsumer(
            '${StringUtils.generateCryptoRandomString()}-orderbook-snapshot',
            '*.*.orderbook-snapshot');

    return consumer;
  }
}
