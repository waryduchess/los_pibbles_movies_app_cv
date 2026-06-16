import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';

class DBConnection {
  static Future<void> initialize({String envFile = '.env'}) async {
    await dotenv.load(fileName: envFile);
  }

  static String get _host => dotenv.env['DB_HOST'] ?? 'localhost';
  static int get _port => int.tryParse(dotenv.env['DB_PORT'] ?? '3306') ?? 3306;
  static String get _user => dotenv.env['DB_USER'] ?? 'root';
  static String get _password => dotenv.env['DB_PASSWORD'] ?? '';
  static String get _db => dotenv.env['DB_NAME'] ?? '';

  static Future<MySQLConnection> getConnection() async {
    final conn = await MySQLConnection.createConnection(
      host: _host,
      port: _port,
      userName: _user,
      password: _password,
      databaseName: _db,
    );
    await conn.connect();
    print('Conexión MySQL exitosa');
    return conn;
  }
}
