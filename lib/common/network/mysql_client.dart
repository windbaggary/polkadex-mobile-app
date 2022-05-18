import "dart:async";
import 'package:mysql_client/mysql_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MysqlClient {
  late MySQLConnection conn;

  Future<dynamic> init() async {
    conn = await MySQLConnection.createConnection(
      host: dotenv.get('DB_HOST'),
      port: int.parse(dotenv.get('DB_PORT')),
      userName: dotenv.get('DB_USER'),
      password: dotenv.get('DB_PASSWORD'),
      databaseName: dotenv.get('DB_NAME'),
    );

    if (!conn.connected) {
      await conn.connect();
    }
  }

  Future<String?> getMainAddress(String proxyAdress) async {
    await init();

    final dbProxyResult = await conn.execute("select * from proxies", {
      "proxyAddress": proxyAdress,
    });
    final dbAccId = dbProxyResult.rows.first.colByName('id');

    final dbMainResult =
        await conn.execute("select * from accounts where id = :acc_id", {
      "acc_id": dbAccId,
    });
    return dbMainResult.rows.first.colByName('main_acc');
  }
}
