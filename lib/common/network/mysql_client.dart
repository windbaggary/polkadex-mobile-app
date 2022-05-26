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

  Future<String?> getAccountId(String proxyAddress) async {
    await init();

    final dbProxyResult =
        await conn.execute("select * from proxies where :proxyAddress", {
      "proxyAddress": proxyAddress,
    });
    return dbProxyResult.rows.first.colByName('id');
  }

  Future<String?> getMainAddress(String proxyAddress) async {
    final dbAccId = getAccountId(proxyAddress);

    final dbMainResult =
        await conn.execute("select * from accounts where id = :acc_id", {
      "acc_id": dbAccId,
    });
    return dbMainResult.rows.first.colByName('main_acc');
  }

  Future<IResultSet> getBalanceAssets(String proxyAddress) async {
    final dbAccId = await getAccountId(proxyAddress);

    return await conn.execute(
        "select free_balance,reserved_balance,asset_type from assets where main_acc = :main_account_id",
        {
          "main_account_id": dbAccId,
        });
  }

  Future<IResultSet> getOrderHistory(String proxyAddress) async {
    final mainAccId = await getAccountId(proxyAddress);

    return await conn.execute(
      "select * from transactions where main_account_id = :main_account_id",
      {
        "main_account_id": mainAccId,
      },
    );
  }
}
