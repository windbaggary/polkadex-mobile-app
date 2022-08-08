import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/graphql/subscriptions.dart';

class UserDataRemoteDatasource {
  Future<Stream> getUserDataStream(
    String address,
  ) async {
    return Amplify.API.subscribe(
      GraphQLRequest(
        document: websocketStreams,
        variables: <String, dynamic>{
          'name': address,
        },
      ),
      onEstablished: () =>
          print('userDataWebsocketStreams subscription established'),
    );
  }
}
