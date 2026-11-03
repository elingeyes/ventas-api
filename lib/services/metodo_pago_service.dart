import 'package:mysql_client/mysql_client.dart';

class MetodoPagoService {
  const MetodoPagoService(this.connection);

  final MySQLConnection connection;

  Future<IResultSet> obtenerActivos() {
    return connection.execute(
      'SELECT id, nombre FROM metodos_pago WHERE activo = 1 ORDER BY nombre',
    );
  }
}
