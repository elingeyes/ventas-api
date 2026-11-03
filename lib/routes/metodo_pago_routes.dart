import 'dart:convert';

import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../services/metodo_pago_service.dart';

Router metodoPagoRoutes(MySQLConnection connection) {
  final router = Router();
  final service = MetodoPagoService(connection);

  router.get('/api/metodos-pago', (Request request) async {
    final resultado = await service.obtenerActivos();
    final metodos =
        resultado.rows
            .map(
              (row) => {
                'id': int.tryParse(row.colAt(0).toString()),
                'nombre': row.colAt(1),
              },
            )
            .toList();

    return Response.ok(
      jsonEncode(metodos),
      headers: {'Content-Type': 'application/json'},
    );
  });

  return router;
}
