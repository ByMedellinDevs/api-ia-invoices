# API IA Invoices - Docker Setup

Este proyecto incluye una configuración completa de Docker para desarrollo y producción de la API de transacciones.

## 🚀 Inicio Rápido

### Prerrequisitos
- Docker
- Docker Compose
- Make (opcional, para comandos simplificados)

### Configuración Inicial

1. **Clonar el repositorio y navegar al directorio:**
   ```bash
   cd api-ia-invoices
   ```

2. **Configurar variables de entorno:**
   ```bash
   cp .env.example .env
   # Editar .env con tus configuraciones
   ```

3. **Iniciar el entorno de desarrollo:**
   ```bash
   # Con Make (recomendado)
   make dev

   # O manualmente con Docker Compose
   docker-compose up -d --build
   ```

4. **Verificar que todo funciona:**
   ```bash
   # Verificar estado de los servicios
   make status
   # o
   docker-compose ps
   ```

## 🐳 Servicios Incluidos

### 🔧 Desarrollo
- **API Rails**: Puerto 3000
- **PostgreSQL**: Puerto 5432
- **Redis**: Puerto 6379

### 🚀 Producción
- **API Rails**: Puerto 80 (a través de Nginx)
- **Nginx**: Proxy reverso con SSL
- **PostgreSQL**: Base de datos
- **Redis**: Cache y jobs

### 🛠️ Herramientas
- **Adminer**: Puerto 8080 (gestión de BD)

## 📋 Comandos Disponibles

### Con Makefile (Recomendado)

```bash
# Configuración inicial
make setup              # Copia .env.example a .env
make dev                # Setup completo para desarrollo

# Gestión de servicios
make up                 # Iniciar servicios
make down               # Detener servicios
make restart            # Reiniciar servicios
make build              # Construir imágenes

# Logs y monitoreo
make logs               # Ver logs de todos los servicios
make logs-api           # Ver logs solo de la API
make logs-db            # Ver logs solo de la BD
make status             # Estado de los servicios

# Acceso a contenedores
make shell              # Bash en el contenedor de Rails
make rails-console      # Consola de Rails
make db-shell           # Shell de PostgreSQL

# Base de datos
make db-migrate         # Ejecutar migraciones
make db-seed            # Ejecutar seeds
make db-reset           # Reset completo de BD

# Testing y limpieza
make test               # Ejecutar tests
make clean              # Limpiar recursos Docker
make clean-all          # Limpieza completa

# Producción
make prod-up            # Iniciar en modo producción
make tools-up           # Iniciar con herramientas
```

### Con Docker Compose Directo

```bash
# Desarrollo
docker-compose up -d --build
docker-compose down
docker-compose logs -f

# Producción
docker-compose --profile production up -d

# Con herramientas
docker-compose --profile tools up -d

# Comandos en contenedores
docker-compose exec api bash
docker-compose exec api rails console
docker-compose exec db psql -U postgres -d api_ia_invoices_development
```

## 🏗️ Estructura del Dockerfile

El Dockerfile soporta múltiples targets:

- **development**: Para desarrollo local
- **production**: Para despliegue en producción
- **build**: Stage intermedio para construcción

```bash
# Construir para desarrollo
docker build -t api-dev --target development ./src

# Construir para producción
docker build -t api-prod --target production ./src
```

## 🌐 URLs de Acceso

### Desarrollo
- **API**: http://localhost:3000
- **Base de datos**: localhost:5432
- **Redis**: localhost:6379
- **Adminer** (con profile tools): http://localhost:8080

### Producción
- **API**: http://localhost (puerto 80)
- **HTTPS**: https://localhost (puerto 443, requiere SSL)

## 🔧 Configuración

### Variables de Entorno Principales

```env
# Base de datos
DATABASE_URL=postgresql://postgres:password@db:5432/api_ia_invoices_development
POSTGRES_PASSWORD=password

# Rails
RAILS_ENV=development
RAILS_MASTER_KEY=your_master_key_here

# Redis
REDIS_URL=redis://redis:6379/0
```

### Volúmenes Persistentes

- `postgres_data`: Datos de PostgreSQL
- `redis_data`: Datos de Redis
- `bundle_cache`: Cache de gems de Ruby
- `rails_cache`: Cache de Rails
- `rails_storage`: Archivos de storage de Rails

## 🚀 Despliegue en Producción

1. **Configurar variables de entorno de producción:**
   ```bash
   cp .env.example .env.production
   # Editar con configuraciones de producción
   ```

2. **Construir imágenes de producción:**
   ```bash
   make prod-build
   ```

3. **Iniciar servicios de producción:**
   ```bash
   make prod-up
   ```

4. **Configurar SSL (opcional):**
   - Colocar certificados en `./ssl/`
   - Descomentar configuración HTTPS en `nginx.conf`

## 🐛 Troubleshooting

### Problemas Comunes

1. **Puerto ya en uso:**
   ```bash
   # Cambiar puertos en docker-compose.yml
   ports:
     - "3001:3000"  # Cambiar puerto local
   ```

2. **Problemas de permisos:**
   ```bash
   # Reconstruir con permisos correctos
   make clean
   make build
   ```

3. **Base de datos no conecta:**
   ```bash
   # Verificar que PostgreSQL esté corriendo
   make logs-db
   
   # Reset de base de datos
   make db-reset
   ```

4. **Gems no instaladas:**
   ```bash
   # Reconstruir imagen
   docker-compose build --no-cache api
   ```

### Logs y Debugging

```bash
# Ver logs en tiempo real
make logs

# Ver logs específicos
make logs-api
make logs-db

# Acceder al contenedor para debugging
make shell
```

## 📚 Comandos Útiles de Rails en Docker

```bash
# Dentro del contenedor (make shell)
rails routes                    # Ver rutas
rails db:migrate:status        # Estado de migraciones
rails console                  # Consola interactiva
rails test                     # Ejecutar tests

# Desde fuera del contenedor
docker-compose exec api rails routes
docker-compose exec api rails console
```

## 🔒 Seguridad

### Configuraciones de Seguridad Incluidas

- Usuario no-root en contenedores
- Headers de seguridad en Nginx
- Rate limiting
- Variables de entorno para secretos
- Volúmenes con permisos restringidos

### Recomendaciones para Producción

1. Cambiar todas las contraseñas por defecto
2. Usar secretos de Docker/Kubernetes
3. Configurar SSL/TLS
4. Implementar monitoreo y logging
5. Configurar backups automáticos

## 📞 Soporte

Para problemas o preguntas:
1. Revisar logs: `make logs`
2. Verificar configuración: `make status`
3. Limpiar y reconstruir: `make clean && make dev`