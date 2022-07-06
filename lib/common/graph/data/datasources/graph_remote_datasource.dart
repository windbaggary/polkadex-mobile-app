import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/graphql/queries.dart';

class GraphRemoteDatasource {
  Future<GraphQLResponse> getCoinGraphData(
    String leftTokenId,
    String rightTokenId,
    String timestamp,
  ) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: getKlinesbyMarketInterval,
            variables: {
              'market': '$leftTokenId-$rightTokenId',
              'interval': timestamp,
              'from': '1970-01-01T00:00:00Z',
              'to': DateTime.now().toUtc().toIso8601String(),
            },
          ),
        )
        .response;
  }
}
