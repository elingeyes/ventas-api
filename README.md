# API Dart de parametrización

La app móvil usa esta API para consultar y administrar productos y clientes, y
para consultar métodos de pago activos. La base de datos es compartida con
`ventas-web`.

Las ventas no se crean ni se modifican desde esta API. La app inicia sesión en
`ventas-web` y registra ventas mediante su API Laravel, que autentica al
vendedor, valida el inventario y guarda la venta y su detalle en una transacción.

## Ejecutar

```sh
dart run bin/server.dart
```

La API queda disponible en `http://localhost:8080`. Rutas principales:

- Documentación Redoc: `http://localhost:8080/docs`
- Especificación OpenAPI: `http://localhost:8080/openapi.json`
- `GET/POST/PUT/DELETE /api/productos`
- `GET/POST/PUT/DELETE /api/clientes`
- `GET /api/metodos-pago`
- `GET /api/ventas`
- `GET /api/ventas/{id}`
- `GET /api/ventas/{id}/detalle`
