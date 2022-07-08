import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/graphql/queries.dart';
import 'package:polkadex/graphql/subscriptions.dart';

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
    return Amplify.API.subscribe(
      GraphQLRequest(
        document: onBalanceUpdate,
        variables: <String, dynamic>{
          'main_account': address,
        },
      ),
      onEstablished: () => print('onBalanceUpdate subscription established'),
    );
  }
}
