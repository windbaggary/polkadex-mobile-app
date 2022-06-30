import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:polkadex/graphql/queries.dart';
import 'package:polkadex/injection_container.dart';

class AddressRemoteDatasource {
  Future<QueryResult> fetchMainAddress(String proxyAddress) async {
    return await dependency<GraphQLClient>().query(
      QueryOptions(
        document: gql(
            findUserByProxyAccount), // this is the query string you just created
        variables: {
          'proxy_account': proxyAddress,
        },
      ),
    );
  }
}
