import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:polkadex/graphql/queries.dart';
import 'package:polkadex/graphql/subscriptions.dart';
import 'package:polkadex/injection_container.dart';

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

  Future<Stream> fetchBalanceStream(String address) async {
    return dependency<GraphQLClient>().subscribe(
      SubscriptionOptions(
        document:
            gql(onBalanceUpdate), // this is the query string you just created
        variables: {
          'main_account': address,
        },
      ),
    );
  }
}
