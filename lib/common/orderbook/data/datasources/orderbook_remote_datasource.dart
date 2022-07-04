import 'package:dart_amqp/dart_amqp.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:polkadex/common/network/rabbit_mq_client.dart';
import 'package:polkadex/common/utils/string_utils.dart';
import 'package:polkadex/graphql/queries.dart';
import 'package:polkadex/injection_container.dart';

class OrderbookRemoteDatasource {
  Future<QueryResult> getOrderbookData(
    String leftTokenId,
    String rightTokenId,
  ) async {
    return await dependency<GraphQLClient>().query(
      QueryOptions(
        document: gql(getOrderbook),
        variables: {
          'market': '$leftTokenId-$rightTokenId',
        },
      ),
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
