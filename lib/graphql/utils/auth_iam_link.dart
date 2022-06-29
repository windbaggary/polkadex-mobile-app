import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql/client.dart';

typedef GetHeaders = FutureOr<Map<String, String>> Function();

class AuthIAMLink extends Link {
  AuthIAMLink();

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final Request req = request.updateContextEntry<HttpLinkHeaders>(
      (HttpLinkHeaders? headers) => HttpLinkHeaders(
        headers: <String, String>{
          ...headers?.headers ?? <String, String>{},
          'Content-Type': 'application/json',
          'x-api-key': dotenv.get('IAM_API_KEY'),
        },
      ),
    );

    yield* forward!(req);
  }
}
