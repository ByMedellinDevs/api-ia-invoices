# API de Transacciones

Esta es una API REST desarrollada en Ruby on Rails para gestionar transacciones con autenticación OAuth2 y arquitectura Trailblazer.

## Características

- **Framework**: Ruby on Rails 8.0.2 (API only)
- **Autenticación**: OAuth2 con Doorkeeper
- **Arquitectura**: Trailblazer para lógica de negocio
- **Base de datos**: PostgreSQL
- **Serialización**: JSON API

## Instalación

1. Instalar dependencias:
```bash
bundle install
```

2. Configurar la base de datos:
```bash
rails db:create
rails db:migrate
rails db:seed
```

3. Iniciar el servidor:
```bash
rails server
```

## Autenticación OAuth2

### Obtener un token de acceso

```bash
curl -X POST http://localhost:3000/oauth/token \
  -H "Content-Type: application/json" \
  -d '{
    "grant_type": "password",
    "username": "admin@example.com",
    "password": "password123",
    "client_id": "api_client_uid",
    "client_secret": "api_client_secret"
  }'
```

Respuesta:
```json
{
  "access_token": "your_access_token_here",
  "token_type": "Bearer",
  "expires_in": 7200,
  "refresh_token": "your_refresh_token_here",
  "scope": "public"
}
```

## Endpoints de la API

### Base URL
```
http://localhost:3000/api/v1
```

### Autenticación
Todos los endpoints requieren un token de acceso válido en el header:
```
Authorization: Bearer your_access_token_here
```

### 1. Listar Transacciones
```
GET /api/v1/transactions
```

**Parámetros de consulta opcionales:**
- `start_date`: Fecha de inicio (YYYY-MM-DD)
- `end_date`: Fecha de fin (YYYY-MM-DD)
- `bank`: Nombre del banco
- `sender_account`: Número de cuenta remitente
- `receiver_account`: Número de cuenta receptor
- `page`: Número de página (default: 1)
- `per_page`: Elementos por página (default: 10)

**Ejemplo:**
```bash
curl -X GET "http://localhost:3000/api/v1/transactions?bank=Bancolombia&page=1" \
  -H "Authorization: Bearer your_access_token_here"
```

### 2. Obtener Transacción por ID
```
GET /api/v1/transactions/:id
```

**Ejemplo:**
```bash
curl -X GET http://localhost:3000/api/v1/transactions/1 \
  -H "Authorization: Bearer your_access_token_here"
```

### 3. Crear Nueva Transacción
```
POST /api/v1/transactions
```

**Cuerpo de la petición:**
```json
{
  "transaction": {
    "transaction_date": "2024-12-30T10:30:00Z",
    "sender_account_number": "1234567890",
    "receiver_account_number": "0987654321",
    "bank": "Bancolombia",
    "reference": "REF123456789",
    "transaction_amount": 1500.50
  }
}
```

**Ejemplo:**
```bash
curl -X POST http://localhost:3000/api/v1/transactions \
  -H "Authorization: Bearer your_access_token_here" \
  -H "Content-Type: application/json" \
  -d '{
    "transaction": {
      "transaction_date": "2024-12-30T10:30:00Z",
      "sender_account_number": "1234567890",
      "receiver_account_number": "0987654321",
      "bank": "Bancolombia",
      "reference": "REF123456789",
      "transaction_amount": 1500.50
    }
  }'
```

### 4. Información del Usuario Actual
```
GET /api/v1/auth/me
```

**Ejemplo:**
```bash
curl -X GET http://localhost:3000/api/v1/auth/me \
  -H "Authorization: Bearer your_access_token_here"
```

## Estructura de Respuesta

### Transacción Exitosa
```json
{
  "data": {
    "id": "1",
    "type": "transaction",
    "attributes": {
      "transaction_date": "2024-12-30T10:30:00.000Z",
      "sender_account_number": "1234567890",
      "receiver_account_number": "0987654321",
      "bank": "Bancolombia",
      "reference": "REF123456789",
      "transaction_amount": "1500.5",
      "created_at": "2024-12-30T15:45:00.000Z",
      "updated_at": "2024-12-30T15:45:00.000Z"
    }
  }
}
```

### Error de Validación
```json
{
  "errors": {
    "transaction_amount": ["must be positive"],
    "reference": ["must be unique"]
  }
}
```

## Validaciones

### Campos Requeridos
- `transaction_date`: Fecha y hora de la transacción
- `sender_account_number`: Número de cuenta remitente (8-20 caracteres)
- `receiver_account_number`: Número de cuenta receptor (8-20 caracteres)
- `bank`: Nombre del banco
- `reference`: Referencia única de la transacción
- `transaction_amount`: Monto de la transacción (mayor a 0)

### Reglas de Negocio
- La referencia debe ser única
- El monto debe ser mayor a 0
- Las cuentas remitente y receptora no pueden ser iguales
- Los números de cuenta deben tener entre 8 y 20 caracteres

## Arquitectura Trailblazer

La aplicación utiliza Trailblazer para organizar la lógica de negocio:

- **Operations**: Coordinan el flujo de trabajo
- **Contracts**: Validan los datos de entrada
- **Serializers**: Formatean las respuestas JSON

### Estructura de Archivos
```
app/
├── concepts/
│   └── transaction/
│       ├── operation/
│       │   ├── create.rb
│       │   ├── index.rb
│       │   └── show.rb
│       └── contract/
│           └── create.rb
├── controllers/
│   └── api/
│       └── v1/
│           ├── transactions_controller.rb
│           └── auth_controller.rb
├── models/
│   ├── transaction.rb
│   └── user.rb
└── serializers/
    └── transaction_serializer.rb
```

## Códigos de Estado HTTP

- `200 OK`: Operación exitosa
- `201 Created`: Recurso creado exitosamente
- `400 Bad Request`: Parámetros inválidos
- `401 Unauthorized`: Token de acceso inválido o faltante
- `404 Not Found`: Recurso no encontrado
- `422 Unprocessable Entity`: Error de validación

## Desarrollo

### Ejecutar Tests
```bash
rails test
```

### Consola de Rails
```bash
rails console
```

### Verificar Rutas
```bash
rails routes
```