import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/graphql/queries.dart';

class AddressRemoteDatasource {
  Future<GraphQLResponse> fetchMainAddress(String proxyAddress) async {
    return await Amplify.API
        .query(
          request: GraphQLRequest(
            document: findUserByProxyAccount,
            variables: {
              'proxy_account': proxyAddress,
            },
          ),
        )
        .response;
  }
}
