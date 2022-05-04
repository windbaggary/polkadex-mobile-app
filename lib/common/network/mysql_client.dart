import "dart:async";
import 'package:mysql1/mysql1.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MysqlClient {
  final settings = ConnectionSettings(
      host: dotenv.get('DB_HOST'),
      port: int.parse(dotenv.get('DB_PORT')),
      user: dotenv.get('DB_USER'),
      password: dotenv.get('DB_PASSWORD'),
      db: dotenv.get('DB_NAME'),
  );

  Future<dynamic> connectToDb() async {
    try {
      final conn = await MySqlConnection.connect(settings);
    } catch (e) {
      print(e);
    }
  }
}
