import 'package:amplify_api/amplify_api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomFunctionProvider extends FunctionAuthProvider {
  const CustomFunctionProvider();

  @override
  Future<String?> getLatestAuthToken() async => dotenv.get('AUTH_TOKEN');
}