import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql/client.dart';
import 'package:polkadex/common/utils/extensions.dart';
import 'app_sync_request.dart';

abstract class CustomIAM {
  static Map<String, String> customAuthHeaders() => {
        'host': dotenv.get('GRAPHQL_ENDPOINT_WEBSOCKET').split('/')[2],
        'x-api-key': dotenv.get('API_KEY'),
      };

  static GraphQLClient customGraphQLClient() => GraphQLClient(
        cache: GraphQLCache(),
        alwaysRebroadcast: true,
        link: Link.split(
          (request) {
            return request.isSubscription;
          },
          WebSocketLink(
            '${dotenv.get('GRAPHQL_ENDPOINT_WEBSOCKET')}?header=${jsonEncode(customAuthHeaders()).toBase64()}&payload=e30=',
            config: SocketClientConfig(
              serializer: AppSyncRequest(
                authHeader: CustomIAM.customAuthHeaders(),
              ),
              inactivityTimeout: Duration(seconds: 60),
            ),
          ),
          HttpLink(
            dotenv.get('GRAPHQL_ENDPOINT'),
            defaultHeaders: {
              'x-api-key': dotenv.get('API_KEY'),
            },
          ),
        ),
      );
}
