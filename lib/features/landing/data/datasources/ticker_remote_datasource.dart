import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/graphql/queries.dart';

class TickerRemoteDatasource {
  Future<GraphQLResponse> getAllTickers() async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: getAllMarketTickers,
          ),
        )
        .response;
  }

  Future<Stream> getTickerStream(
    String leftTokenId,
    String rightTokenId,
  ) async {
    return Amplify.API.subscribe(
      GraphQLRequest(
        document: '', //TODO: update ticker stream using websocket-streams
        variables: {
          'm': '$leftTokenId-$rightTokenId',
        },
      ),
      onEstablished: () => print(
          'onNewTicker $leftTokenId-$rightTokenId subscription established'),
    );
  }
}
