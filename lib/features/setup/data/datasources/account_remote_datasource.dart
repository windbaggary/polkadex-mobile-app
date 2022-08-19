import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class AccountRemoteDatasource {
  Future<SignUpResult> signUp(
    String email,
    String password,
  ) async {
    return await Amplify.Auth.signUp(
      username: email,
      password: password,
      options: CognitoSignUpOptions(
        userAttributes: {
          CognitoUserAttributeKey.email: email,
        },
      ),
    );
  }

  Future<SignUpResult> confirmSignUp(
    String email,
    String code,
  ) async {
    return await Amplify.Auth.confirmSignUp(
      username: email,
      confirmationCode: code,
    );
  }

  Future<SignInResult> signIn(
    String email,
    String password,
  ) async {
    return await Amplify.Auth.signIn(
      username: email,
      password: password,
    );
  }

  Future<SignOutResult> signOut() async {
    return await Amplify.Auth.signOut();
  }

  Future<AuthUser> getCurrentUser() async {
    return await Amplify.Auth.getCurrentUser();
  }

  Future<ResendSignUpCodeResult> resendCode(String email) async {
    return await Amplify.Auth.resendSignUpCode(username: email);
  }
}
