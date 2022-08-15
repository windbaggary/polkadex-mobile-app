import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/graphql/queries.dart';

class BalanceRemoteDatasource {
  Future<GraphQLResponse> fetchBalance(String address) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: getAllBalancesByMainAccount,
            variables: <String, dynamic>{
              'main_account': address,
            },
          ),
        )
        .response;
  }
}
