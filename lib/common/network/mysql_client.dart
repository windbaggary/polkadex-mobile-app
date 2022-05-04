import "dart:async";
import 'package:mysql1/mysql1.dart';

class MysqlClient {
  final settings = ConnectionSettings(
    host: '',
    port: 0000,
    user: '',
    password: '',
    db: '',
  );

  Future<dynamic> connectToDb() async {
    try {
      await MySqlConnection.connect(settings);
    } catch (e) {
      print(e);
    }
  }
}
