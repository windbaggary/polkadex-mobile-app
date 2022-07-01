import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:polkadex/graphql/queries.dart';
import 'package:polkadex/graphql/subscriptions.dart';
import 'package:polkadex/injection_container.dart';

class BalanceRemoteDatasource {
  Future<QueryResult> fetchBalance(String address) async {
    return await dependency<GraphQLClient>().query(
      QueryOptions(
        document: gql(
            getAllBalancesByMainAccount), // this is the query string you just created
        variables: {
          'main_account': address,
        },
      ),
    );
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
