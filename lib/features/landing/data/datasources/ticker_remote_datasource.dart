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
}
