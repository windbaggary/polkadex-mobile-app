import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/graphql/queries.dart';
import 'package:polkadex/graphql/subscriptions.dart';

class OrderbookRemoteDatasource {
  Future<GraphQLResponse> getOrderbookData(
    String leftTokenId,
    String rightTokenId,
  ) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: getOrderbook,
            variables: {
              'market': '$leftTokenId-$rightTokenId',
            },
          ),
        )
        .response;
  }

  Future<Stream> getOrderbookStream(
    String leftTokenId,
    String rightTokenId,
  ) async {
    return Amplify.API.subscribe(
      GraphQLRequest(
        document: websocketStreams,
        variables: <String, dynamic>{
          'name': '$leftTokenId-$rightTokenId-ob-inc',
        },
      ),
      onEstablished: () => print('orderbookUpdate subscription established'),
    );
  }
}
