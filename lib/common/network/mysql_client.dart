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
  }

  Future<dynamic> connect() async {
    try {
      if (!conn.connected) {
        conn.connect();
      }
    } catch (e) {
      print(e);
    }
  }
}
