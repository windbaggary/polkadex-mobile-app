import 'package:polkadex/common/network/blockchain_rpc_helper.dart';
import 'package:polkadex/common/web_view_runner/web_view_runner.dart';
import 'package:polkadex/injection_container.dart';

class CoinRemoteDatasource {
  Future<void> withdraw(
    String mainAddress,
    String proxyAddress,
    String asset,
    double amount,
  ) async {
    final nonce = await BlockchainRpcHelper.sendRpcRequest(
        'enclave_getNonce', [mainAddress]);

    final String _callWithdrawJSON =
        "polkadexWorker.withdrawJSON(keyring.getPair('$proxyAddress'), ${nonce + 1}, '$asset', $amount)";
    final List<dynamic> payloadResult = await dependency<WebViewRunner>()
        .evalJavascript(_callWithdrawJSON, isSynchronous: true);

    return await BlockchainRpcHelper.sendRpcRequest(
        'enclave_withdraw', payloadResult);
  }
}
