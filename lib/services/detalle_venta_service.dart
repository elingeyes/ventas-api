import 'package:mysql_client/mysql_client.dart';

class DetalleVentaService {
  final MySQLConnection connection;

  DetalleVentaService(this.connection);

  Future<IResultSet> obtenerTodos() async {
    return await connection.execute('''
      SELECT dv.id, dv.venta_id, dv.producto_id, p.nombre AS producto,
             dv.cantidad, dv.precio_unitario, dv.subtotal
      FROM detalle_venta dv
      INNER JOIN productos p ON p.id = dv.producto_id
      ORDER BY dv.id DESC
      ''');
  }

  Future<IResultSet> obtenerPorId(int id) async {
    return await connection.execute(
      '''
      SELECT dv.id, dv.venta_id, dv.producto_id, p.nombre AS producto,
             dv.cantidad, dv.precio_unitario, dv.subtotal
      FROM detalle_venta dv
      INNER JOIN productos p ON p.id = dv.producto_id
      WHERE dv.id = :id
      ''',
      {'id': id},
    );
  }
}
