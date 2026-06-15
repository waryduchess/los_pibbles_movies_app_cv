import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql1/mysql1.dart';

/// - Llamar `await DBConnection.initialize()` una vez al iniciar la app
/// - Obtener una conexión con `final conn = await DBConnection.getConnection();`.
/// - Cerrar la conexión con `await conn.close();` cuando termines.
class DBConnection {
  static ConnectionSettings? _settings;

  /// Inicializa la configuración leyendo `.env` (si existe) y preparando los settings.
  static Future<void> initialize({String envFile = '.env'}) async {
    await dotenv.load(fileName: envFile);

    _settings = ConnectionSettings(
      host: dotenv.env['DB_HOST'] ?? 'localhost',
      port: int.tryParse(dotenv.env['DB_PORT'] ?? '3306') ?? 3306,
      user: dotenv.env['DB_USER'] ?? 'root',
      password: dotenv.env['DB_PASSWORD'] ?? '',
      db: dotenv.env['DB_NAME'] ?? '',
    );
  }

  /// Crea y devuelve una nueva conexión MySQL usando `mysql1`.
  /// podríamos implementar  una conexión reutilizable. INVESTIGAR COMO HACERLO
  static Future<MySqlConnection> getConnection() async {
    if (_settings == null) {
      await initialize();
    }
    try {
      final conn = await MySqlConnection.connect(_settings!);
      print('Conexión MySQL exitosa');
      return conn;
    } catch (e) {
      print('No se pudo conectar a la base de datos: $e');
      rethrow;
    }
  }
}
