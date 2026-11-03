import 'dart:convert';

import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/venta_service.dart';

Router ventaRoutes(MySQLConnection connection) {
  final router = Router();
  final service = VentaService(connection);

  router.get('/api/ventas', (Request request) async {
    final resultado = await service.obtenerTodos();

    final ventas =
        resultado.rows.map((row) {
          return {
            'id': int.tryParse(row.colAt(0).toString()) ?? 0,
            'cliente_id': int.tryParse(row.colAt(1).toString()) ?? 0,
            'fecha': row.colAt(2),
            'total': double.tryParse(row.colAt(3).toString()) ?? 0,
            'estado': row.colAt(4),
          };
        }).toList();

    return Response.ok(
      jsonEncode(ventas),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.get('/api/ventas/<id>', (Request request) async {
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
        jsonEncode({'error': 'Venta no encontrada'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final row = resultado.rows.first;
    final venta = {
      'id': int.tryParse(row.colAt(0).toString()) ?? 0,
      'cliente_id': int.tryParse(row.colAt(1).toString()) ?? 0,
      'fecha': row.colAt(2),
      'total': double.tryParse(row.colAt(3).toString()) ?? 0,
      'estado': row.colAt(4),
    };

    return Response.ok(
      jsonEncode(venta),
      headers: {'Content-Type': 'application/json'},
    );
  });

  router.get('/api/ventas/<id>/detalle', (Request request) async {
    final id = int.tryParse(request.params['id']!);

    if (id == null) {
      return Response.badRequest(
        body: jsonEncode({'error': 'El ID debe ser numérico'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final resultado = await service.obtenerConDetalle(id);

    if (resultado.rows.isEmpty) {
      return Response.notFound(
        jsonEncode({'error': 'Venta no encontrada'}),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final venta = {
      'id': int.tryParse(resultado.rows.first.colAt(0).toString()) ?? 0,
      'cliente_id': int.tryParse(resultado.rows.first.colAt(1).toString()) ?? 0,
      'fecha': resultado.rows.first.colAt(2),
      'total': double.tryParse(resultado.rows.first.colAt(3).toString()) ?? 0,
      'estado': resultado.rows.first.colAt(4),
    };

    final detalle =
        resultado.rows.where((row) => row.colAt(5) != null).map((row) {
          return {
            'id': int.tryParse(row.colAt(5).toString()) ?? 0,
            'producto_id': int.tryParse(row.colAt(6).toString()) ?? 0,
            'producto': row.colAt(7),
            'cantidad': int.tryParse(row.colAt(8).toString()) ?? 0,
            'precio_unitario': double.tryParse(row.colAt(9).toString()) ?? 0,
            'subtotal': double.tryParse(row.colAt(10).toString()) ?? 0,
          };
        }).toList();

    return Response.ok(
      jsonEncode({'venta': venta, 'detalle': detalle}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  return router;
}
