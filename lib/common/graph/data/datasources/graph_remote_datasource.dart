import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:polkadex/injection_container.dart';
import 'package:polkadex/graphql/queries.dart';

class GraphRemoteDatasource {
  Future<QueryResult> getCoinGraphData(
    String leftTokenId,
    String rightTokenId,
    String timestamp,
  ) async {
    return await dependency<GraphQLClient>().query(
      QueryOptions(
        document: gql(
            getKlinesbyMarketInterval), // this is the query string you just created
        variables: {
          'market': '$leftTokenId-$rightTokenId',
          'interval': timestamp,
          'from': '1970-01-01T00:00:00Z',
          'to': DateTime.now().toUtc().toIso8601String(),
        },
      ),
    );
  }
}
