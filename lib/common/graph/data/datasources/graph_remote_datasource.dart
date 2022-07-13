import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/graphql/queries.dart';

class GraphRemoteDatasource {
  Future<GraphQLResponse> getCoinGraphData(
    String leftTokenId,
    String rightTokenId,
    String timestamp,
    DateTime from,
    DateTime to,
  ) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: getKlinesbyMarketInterval,
            variables: {
              'market': '$leftTokenId-$rightTokenId',
              'interval': timestamp,
              'from': from.toUtc().toIso8601String(),
              'to': to.toUtc().toIso8601String(),
            },
          ),
        )
        .response;
  }
}
