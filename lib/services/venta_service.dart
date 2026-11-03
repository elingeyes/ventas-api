import 'package:mysql_client/mysql_client.dart';

class VentaService {
  final MySQLConnection connection;

  VentaService(this.connection);

  Future<IResultSet> obtenerTodos() async {
    return await connection.execute(
      'SELECT id, cliente_id, fecha, total, estado FROM ventas ORDER BY id DESC',
    );
  }

  Future<IResultSet> obtenerPorId(int id) async {
    return await connection.execute(
      'SELECT id, cliente_id, fecha, total, estado FROM ventas WHERE id = :id',
      {'id': id},
    );
  }

  Future<IResultSet> obtenerConDetalle(int id) async {
    return await connection.execute(
      '''
      SELECT v.id, v.cliente_id, v.fecha, v.total, v.estado,
             dv.id AS detalle_id,
             dv.producto_id,
             p.nombre AS producto,
             dv.cantidad,
             dv.precio_unitario,
             dv.subtotal
      FROM ventas v
      LEFT JOIN detalle_venta dv ON dv.venta_id = v.id
      LEFT JOIN productos p ON p.id = dv.producto_id
      WHERE v.id = :id
      ORDER BY dv.id ASC
      ''',
      {'id': id},
    );
  }
}
