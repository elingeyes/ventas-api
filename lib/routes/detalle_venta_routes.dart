import 'dart:convert';

import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/detalle_venta_service.dart';

Router detalleVentaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = DetalleVentaService(connection);

  router.get('/api/detalle-ventas', (Request request) async {
    final resultado = await service.obtenerTodos();

    final detalles =
        resultado.rows.map((row) {
          return {
            'id': int.tryParse(row.colAt(0).toString()) ?? 0,
            'venta_id': int.tryParse(row.colAt(1).toString()) ?? 0,
            'producto_id': int.tryParse(row.colAt(2).toString()) ?? 0,
            'producto': row.colAt(3),
            'cantidad': int.tryParse(row.colAt(4).toString()) ?? 0,
            'precio_unitario': double.tryParse(row.colAt(5).toString()) ?? 0,
            'subtotal': double.tryParse(row.colAt(6).toString()) ?? 0,
          };
        }).toList();

    return Response.ok(
      jsonEncode(detalles),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.get('/api/detalle-ventas/<id>', (Request request) async {
    final id = int.tryParse(request.params['id']!);

    if (id == null) {
      return Response.badRequest(
        body: jsonEncode({'error': 'El ID debe ser numérico'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final resultado = await service.obtenerPorId(id);

    if (resultado.rows.isEmpty) {
      return Response.notFound(
        jsonEncode({'error': 'Detalle de venta no encontrado'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final row = resultado.rows.first;
    final detalle = {
      'id': int.tryParse(row.colAt(0).toString()) ?? 0,
      'venta_id': int.tryParse(row.colAt(1).toString()) ?? 0,
      'producto_id': int.tryParse(row.colAt(2).toString()) ?? 0,
      'producto': row.colAt(3),
      'cantidad': int.tryParse(row.colAt(4).toString()) ?? 0,
      'precio_unitario': double.tryParse(row.colAt(5).toString()) ?? 0,
      'subtotal': double.tryParse(row.colAt(6).toString()) ?? 0,
    };

    return Response.ok(
      jsonEncode(detalle),
      headers: {'Content-Type': 'application/json'},
    );
  });

  return router;
}
