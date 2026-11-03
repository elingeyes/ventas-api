const openApiSpec = {
  'openapi': '3.0.3',
  'info': {
    'title': 'API Dart de parametrización',
    'version': '1.0.0',
    'description':
        'API para consultar y administrar productos y clientes, consultar métodos de pago y consultar ventas. El registro de ventas se realiza mediante la API Laravel.',
  },
  'servers': [
    {'url': '/api', 'description': 'Servidor actual'},
  ],
  'tags': [
    {'name': 'Productos'},
    {'name': 'Clientes'},
    {'name': 'Métodos de pago'},
    {'name': 'Ventas'},
    {'name': 'Detalles de venta'},
  ],
  'paths': {
    '/productos': {
      'get': {
        'tags': ['Productos'],
        'summary': 'Listar productos',
        'responses': {
          '200': {
            'description': 'Productos encontrados',
            'content': {
              'application/json': {
                'schema': {
                  'type': 'array',
                  'items': {'\$ref': '#/components/schemas/Producto'},
                },
              },
            },
          },
        },
      },
      'post': {
        'tags': ['Productos'],
        'summary': 'Crear producto',
        'requestBody': {
          'required': true,
          'content': {
            'application/json': {
              'schema': {'\$ref': '#/components/schemas/ProductoInput'},
            },
          },
        },
        'responses': {
          '201': {
            'description': 'Producto creado',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/Mensaje'},
              },
            },
          },
          '400': {'description': 'Datos de producto inválidos'},
        },
      },
    },
    '/productos/{id}': {
      'parameters': [
        {
          'name': 'id',
          'in': 'path',
          'required': true,
          'schema': {'type': 'integer'},
        },
      ],
      'get': {
        'tags': ['Productos'],
        'summary': 'Obtener producto',
        'responses': {
          '200': {
            'description': 'Producto encontrado',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/Producto'},
              },
            },
          },
          '400': {'description': 'El ID debe ser numérico'},
          '404': {'description': 'Producto no encontrado'},
        },
      },
      'put': {
        'tags': ['Productos'],
        'summary': 'Actualizar producto',
        'requestBody': {
          'required': true,
          'content': {
            'application/json': {
              'schema': {'\$ref': '#/components/schemas/ProductoInput'},
            },
          },
        },
        'responses': {
          '200': {
            'description': 'Producto actualizado',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/Mensaje'},
              },
            },
          },
          '400': {'description': 'ID o datos de producto inválidos'},
          '404': {'description': 'Producto no encontrado'},
        },
      },
      'delete': {
        'tags': ['Productos'],
        'summary': 'Eliminar producto',
        'responses': {
          '200': {
            'description': 'Producto eliminado',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/Mensaje'},
              },
            },
          },
          '400': {'description': 'El ID debe ser numérico'},
          '404': {'description': 'Producto no encontrado'},
        },
      },
    },
    '/clientes': {
      'get': {
        'tags': ['Clientes'],
        'summary': 'Listar clientes',
        'responses': {
          '200': {
            'description': 'Clientes encontrados',
            'content': {
              'application/json': {
                'schema': {
                  'type': 'array',
                  'items': {'\$ref': '#/components/schemas/Cliente'},
                },
              },
            },
          },
        },
      },
      'post': {
        'tags': ['Clientes'],
        'summary': 'Crear cliente',
        'requestBody': {
          'required': true,
          'content': {
            'application/json': {
              'schema': {'\$ref': '#/components/schemas/ClienteInput'},
            },
          },
        },
        'responses': {
          '201': {
            'description': 'Cliente creado',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/ClienteCreated'},
              },
            },
          },
          '400': {'description': 'Datos de cliente inválidos'},
        },
      },
    },
    '/clientes/{id}': {
      'parameters': [
        {
          'name': 'id',
          'in': 'path',
          'required': true,
          'schema': {'type': 'integer'},
        },
      ],
      'get': {
        'tags': ['Clientes'],
        'summary': 'Obtener cliente',
        'responses': {
          '200': {
            'description': 'Cliente encontrado',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/Cliente'},
              },
            },
          },
          '400': {'description': 'El ID debe ser numérico'},
          '404': {'description': 'Cliente no encontrado'},
        },
      },
      'put': {
        'tags': ['Clientes'],
        'summary': 'Actualizar cliente',
        'requestBody': {
          'required': true,
          'content': {
            'application/json': {
              'schema': {'\$ref': '#/components/schemas/ClienteInput'},
            },
          },
        },
        'responses': {
          '200': {
            'description': 'Cliente actualizado',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/Mensaje'},
              },
            },
          },
          '400': {'description': 'ID o datos de cliente inválidos'},
          '404': {'description': 'Cliente no encontrado'},
        },
      },
      'delete': {
        'tags': ['Clientes'],
        'summary': 'Eliminar cliente',
        'responses': {
          '200': {
            'description': 'Cliente eliminado',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/Mensaje'},
              },
            },
          },
          '400': {'description': 'El ID debe ser numérico'},
          '404': {'description': 'Cliente no encontrado'},
        },
      },
    },
    '/metodos-pago': {
      'get': {
        'tags': ['Métodos de pago'],
        'summary': 'Listar métodos de pago activos',
        'responses': {
          '200': {
            'description': 'Métodos de pago activos',
            'content': {
              'application/json': {
                'schema': {
                  'type': 'array',
                  'items': {'\$ref': '#/components/schemas/MetodoPago'},
                },
              },
            },
          },
        },
      },
    },
    '/ventas': {
      'get': {
        'tags': ['Ventas'],
        'summary': 'Listar ventas',
        'responses': {
          '200': {
            'description': 'Ventas encontradas',
            'content': {
              'application/json': {
                'schema': {
                  'type': 'array',
                  'items': {'\$ref': '#/components/schemas/Venta'},
                },
              },
            },
          },
        },
      },
    },
    '/ventas/{id}': {
      'parameters': [
        {
          'name': 'id',
          'in': 'path',
          'required': true,
          'schema': {'type': 'integer'},
        },
      ],
      'get': {
        'tags': ['Ventas'],
        'summary': 'Obtener venta',
        'responses': {
          '200': {
            'description': 'Venta encontrada',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/Venta'},
              },
            },
          },
          '400': {'description': 'El ID debe ser numérico'},
          '404': {'description': 'Venta no encontrada'},
        },
      },
    },
    '/ventas/{id}/detalle': {
      'parameters': [
        {
          'name': 'id',
          'in': 'path',
          'required': true,
          'schema': {'type': 'integer'},
        },
      ],
      'get': {
        'tags': ['Ventas'],
        'summary': 'Consultar venta y su detalle',
        'responses': {
          '200': {
            'description': 'Venta con detalle',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/VentaConDetalle'},
              },
            },
          },
          '400': {'description': 'El ID debe ser numérico'},
          '404': {'description': 'Venta no encontrada'},
        },
      },
    },
    '/detalle-ventas': {
      'get': {
        'tags': ['Detalles de venta'],
        'summary': 'Listar detalles de venta',
        'responses': {
          '200': {
            'description': 'Detalles encontrados',
            'content': {
              'application/json': {
                'schema': {
                  'type': 'array',
                  'items': {'\$ref': '#/components/schemas/DetalleVenta'},
                },
              },
            },
          },
        },
      },
    },
    '/detalle-ventas/{id}': {
      'parameters': [
        {
          'name': 'id',
          'in': 'path',
          'required': true,
          'schema': {'type': 'integer'},
        },
      ],
      'get': {
        'tags': ['Detalles de venta'],
        'summary': 'Obtener detalle de venta',
        'responses': {
          '200': {
            'description': 'Detalle encontrado',
            'content': {
              'application/json': {
                'schema': {'\$ref': '#/components/schemas/DetalleVenta'},
              },
            },
          },
          '400': {'description': 'El ID debe ser numérico'},
          '404': {'description': 'Detalle de venta no encontrado'},
        },
      },
    },
  },
  'components': {
    'schemas': {
      'Producto': {
        'type': 'object',
        'properties': {
          'id': {'type': 'integer'},
          'nombre': {'type': 'string'},
          'precio': {'type': 'number', 'format': 'double'},
        },
      },
      'ProductoInput': {
        'type': 'object',
        'required': ['nombre', 'precio'],
        'properties': {
          'nombre': {'type': 'string'},
          'precio': {'type': 'number', 'format': 'double'},
        },
      },
      'Cliente': {
        'type': 'object',
        'properties': {
          'id': {'type': 'integer'},
          'nombre': {'type': 'string'},
          'apellido': {'type': 'string', 'nullable': true},
          'telefono': {'type': 'string', 'nullable': true},
          'email': {'type': 'string', 'format': 'email', 'nullable': true},
        },
      },
      'ClienteInput': {
        'type': 'object',
        'required': ['nombre'],
        'properties': {
          'nombre': {'type': 'string'},
          'apellido': {'type': 'string', 'nullable': true},
          'telefono': {'type': 'string', 'nullable': true},
          'email': {'type': 'string', 'format': 'email', 'nullable': true},
        },
      },
      'ClienteCreated': {
        'type': 'object',
        'properties': {
          'mensaje': {'type': 'string'},
          'id': {'type': 'integer', 'nullable': true},
        },
      },
      'MetodoPago': {
        'type': 'object',
        'properties': {
          'id': {'type': 'integer'},
          'nombre': {'type': 'string'},
        },
      },
      'Venta': {
        'type': 'object',
        'properties': {
          'id': {'type': 'integer'},
          'cliente_id': {'type': 'integer'},
          'fecha': {'type': 'string', 'format': 'date-time'},
          'total': {'type': 'number', 'format': 'double'},
          'estado': {'type': 'string'},
        },
      },
      'VentaConDetalle': {
        'type': 'object',
        'properties': {
          'venta': {'\$ref': '#/components/schemas/Venta'},
          'detalle': {
            'type': 'array',
            'items': {'\$ref': '#/components/schemas/DetalleVenta'},
          },
        },
      },
      'DetalleVenta': {
        'type': 'object',
        'properties': {
          'id': {'type': 'integer'},
          'venta_id': {'type': 'integer'},
          'producto_id': {'type': 'integer'},
          'producto': {'type': 'string', 'nullable': true},
          'cantidad': {'type': 'integer'},
          'precio_unitario': {'type': 'number', 'format': 'double'},
          'subtotal': {'type': 'number', 'format': 'double'},
        },
      },
      'Mensaje': {
        'type': 'object',
        'properties': {
          'mensaje': {'type': 'string'},
        },
      },
    },
  },
};

const redocHtml = '''
<!DOCTYPE html>
<html lang="es">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>API Dart - Documentación</title>
    <style>body { margin: 0; }</style>
  </head>
  <body>
    <redoc spec-url="/openapi.json"></redoc>
    <script type="module" src="https://cdn.redoc.ly/redoc/v3.x/bundles/redoc.standalone.js"></script>
  </body>
</html>
''';
