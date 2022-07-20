import "dart:async";
import 'package:json_rpc_2/json_rpc_2.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class BlockchainRpcHelper {
  static Future<dynamic> sendRpcRequest(
      String methodName, dynamic payload) async {
    try {
      var socket =
          WebSocketChannel.connect(Uri.parse(dotenv.get('BLOCKCHAIN_URL')));
      var client = Client(socket.cast<String>());
      client.listen();

      final result = await client.sendRequest(methodName, payload);
      client.close();

      return result;
    } on RpcException {
      rethrow;
    }
  }
}
