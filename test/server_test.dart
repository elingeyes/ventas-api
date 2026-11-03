import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  late String host;
  late Process p;

  setUp(() async {
    p = await Process.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {'PORT': '0'},
    );

    final readyLine = await p.stdout
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .firstWhere(
          (line) => line.startsWith('Servidor ejecutándose en http://'),
        );
    final serverUri = Uri.parse(readyLine.split(' ').last);
    host = 'http://127.0.0.1:${serverUri.port}';
  });

  tearDown(() async {
    if (p.kill()) {
      await p.exitCode;
    }
  });

  test('Root devuelve la API', () async {
    final response = await get(Uri.parse('$host/'));
    expect(response.statusCode, 200);
    expect(response.body, 'API Dart funcionando correctamente\n');
  });

  test('Redoc y la especificación OpenAPI están disponibles', () async {
    final docsResponse = await get(Uri.parse('$host/docs'));
    expect(docsResponse.statusCode, 200);
    expect(docsResponse.headers['content-type'], contains('text/html'));
    expect(docsResponse.body, contains('<redoc spec-url="/openapi.json">'));

    final specResponse = await get(Uri.parse('$host/openapi.json'));
    expect(specResponse.statusCode, 200);
    expect(specResponse.headers['content-type'], contains('application/json'));
    final spec = jsonDecode(specResponse.body);
    expect(spec['openapi'], '3.0.3');
    expect(spec['paths'], contains('/productos'));
    expect(spec['paths'], contains('/metodos-pago'));
    expect(spec['paths'], contains('/ventas/{id}/detalle'));
  });

  test('Lista productos', () async {
    final response = await get(Uri.parse('$host/api/productos'));
    expect(response.statusCode, 200);
    final decoded = jsonDecode(response.body);
    expect(decoded, isA<List>());
  });

  test('Lista métodos de pago activos para registrar ventas', () async {
    final response = await get(Uri.parse('$host/api/metodos-pago'));
    expect(response.statusCode, 200);
    final decoded = jsonDecode(response.body);
    expect(decoded, isA<List>());
    if ((decoded as List).isNotEmpty) {
      expect(decoded.first, containsPair('id', isA<int>()));
      expect(decoded.first, contains('nombre'));
    }
  });

  test('CRUD de clientes', () async {
    final unique = DateTime.now().millisecondsSinceEpoch;
    final createResponse = await post(
      Uri.parse('$host/api/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': 'Cliente',
        'apellido': 'Prueba',
        'telefono': '5551234',
        'email': 'cliente_$unique@test.com',
      }),
    );

    expect(createResponse.statusCode, 201);

    final createBody = jsonDecode(createResponse.body);
    final id = createBody['id'];
    expect(id, isNotNull);

    final getResponse = await get(Uri.parse('$host/api/clientes/$id'));
    expect(getResponse.statusCode, 200);

    final client = jsonDecode(getResponse.body);
    expect(client['nombre'], 'Cliente');
    expect(client['email'], 'cliente_$unique@test.com');
  });

  test('La API Dart no registra ventas ni detalles', () async {
    final venta = await post(
      Uri.parse('$host/api/ventas/transaccional'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cliente_id': 1,
        'items': [
          {'producto_id': 1, 'cantidad': 1},
        ],
      }),
    );
    final detalle = await post(
      Uri.parse('$host/api/detalle-ventas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'venta_id': 1,
        'producto_id': 1,
        'cantidad': 1,
        'precio_unitario': 1,
      }),
    );

    expect(venta.statusCode, 404);
    expect(detalle.statusCode, 404);
  });
}
