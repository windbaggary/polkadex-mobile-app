import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:polkadex/common/utils/math_utils.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';
import 'package:polkadex/graphql/mutations.dart' as mutations;

class CoinRemoteDatasource {
  Future<GraphQLResponse> withdraw(
    String mainAddress,
    String proxyAddress,
    String asset,
    double amount,
  ) async {
    final nonce = MathUtils.getNonce();

    final String _callWithdrawJSON =
        "polkadexWorker.withdrawJSON(keyring.getPair('$proxyAddress'), $nonce, '$asset', $amount)";
    final List<dynamic> payloadResult = await dependency<WebViewRunner>()
        .evalJavascript(_callWithdrawJSON, isSynchronous: true);

    return await Amplify.API
        .mutate(
          request: GraphQLRequest(
            document: mutations.withdraw,
            variables: {
              'input': {'Withdraw': payloadResult},
            },
          ),
        )
        .response;
  }
}
