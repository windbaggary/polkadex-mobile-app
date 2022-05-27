import "dart:async";
import "package:dart_amqp/dart_amqp.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RabbitMqClient {
  final Completer connected = Completer();
  final Client _client;
  bool _isConnected = false;
  late Exchange _exchange;
  late Channel _channel;

  RabbitMqClient()
      : _client = Client(
          settings: ConnectionSettings(
            host: dotenv.get('RMQ_URL'),
            virtualHost: dotenv.get('RMQ_VHOST'),
            authProvider: AmqPlainAuthenticator(
              dotenv.get('RMQ_USERNAME'),
              dotenv.get('RMQ_KEY'),
            ),
          ),
        );

  bool get isConnected => _isConnected;
  Exchange get exchange => _exchange;

  Future<void> init() async {
    try {
      _channel = await _client.channel();

      _isConnected = true;
      print('Connected to rabbitmq server');

      _exchange = await _channel.exchange('topic_exchange', ExchangeType.TOPIC);
    } catch (e) {
      print(e);
    }
  }

  Future<Consumer?> tryBindQueueToConsumer(String queueName, String routingKey,
      {bool nullOnError = false}) async {
    try {
      final queue = await _channel.queue(queueName, autoDelete: true);
      await queue.bind(_exchange, routingKey);

      return await queue.consume();
    } catch (_) {
      if (!nullOnError) {
        await init();
        return await tryBindQueueToConsumer(queueName, routingKey,
            nullOnError: true);
      } else {
        return null;
      }
    }
  }
}
