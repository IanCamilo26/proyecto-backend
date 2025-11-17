# Backend - Users API

API REST desarrollada con Django y Django REST Framework para la gestión de usuarios.

## Requisitos Previos

- Python 3.9 o superior
- pip (gestor de paquetes de Python)
- PostgreSQL (para producción) o SQLite (desarrollo local)

## Instalación Local

### 1. Clonar el repositorio

```bash
cd proyecto-backend
```

### 2. Crear y activar entorno virtual

**En Windows:**
```bash
python -m venv venv
venv\Scripts\activate
```

**En Linux/Mac:**
```bash
python3 -m venv venv
source venv/bin/activate
```

### 3. Instalar dependencias

```bash
pip install -r requirements.txt
```

### 4. Configurar variables de entorno

Crear un archivo `.env` en la raíz del proyecto:

```env
# Base de datos
DB_NAME=users_db
DB_USER=postgres
DB_PASSWORD=your_password
DB_HOST=localhost
DB_PORT=5432

# Django
SECRET_KEY=your-secret-key-here
DEBUG=True
ALLOWED_HOSTS=localhost,127.0.0.1

# URL del servicio de notificaciones
NOTIFICATION_URL=http://localhost:8080

# CORS
CORS_ALLOWED_ORIGINS=http://localhost:5500,http://127.0.0.1:5500
```

### 5. Aplicar migraciones

```bash
python manage.py makemigrations
python manage.py migrate
```

### 6. Crear superusuario (opcional)

```bash
python manage.py createsuperuser
```

## Ejecutar el Servidor

### Modo desarrollo

```bash
python manage.py runserver
```

El servidor estará disponible en: `http://localhost:8000`

### Ejecutar en un puerto específico

```bash
python manage.py runserver 8000
```

## Endpoints Disponibles

### Usuarios

- **GET** `/api/users/` - Listar todos los usuarios
- **POST** `/api/users/` - Crear nuevo usuario
- **GET** `/api/users/{id}/` - Obtener usuario específico
- **PUT** `/api/users/{id}/` - Actualizar usuario
- **DELETE** `/api/users/{id}/` - Eliminar usuario

### Health Check

- **GET** `/api/health/` - Verificar estado del servicio

### Ejemplo de petición POST:

```json
{
  "name": "Juan Pérez",
  "email": "juan@example.com",
  "phone": "099123456"
}
```

## Construir Imagen Docker

```bash
docker build -t proyecto-backend:latest .
```

### Ejecutar contenedor localmente

```bash
docker run -p 8000:8000 \
  -e DB_HOST=host.docker.internal \
  -e DB_NAME=users_db \
  -e DB_USER=postgres \
  -e DB_PASSWORD=your_password \
  proyecto-backend:latest
```

## Ejecutar Tests

```bash
python manage.py test
```

## Estructura del Proyecto

```
proyecto-backend/
├── backend/
│   ├── settings.py       # Configuración de Django
│   ├── urls.py          # URLs principales
│   └── wsgi.py
├── users/
│   ├── models.py        # Modelos de datos
│   ├── serializers.py   # Serializers de DRF
│   ├── views.py         # Vistas/Endpoints
│   ├── urls.py          # URLs de la app
│   └── signals.py       # Señales para notificaciones
├── manage.py
├── requirements.txt
├── Dockerfile
└── README.md
```

## Comandos Útiles

### Ver logs del servidor
```bash
python manage.py runserver --verbosity 2
```

### Limpiar base de datos
```bash
python manage.py flush
```

### Crear migraciones
```bash
python manage.py makemigrations users
```

### Ver SQL de migraciones
```bash
python manage.py sqlmigrate users 0001
```

### Shell interactivo
```bash
python manage.py shell
```

## Acceder al Admin de Django

1. Crear superusuario:
```bash
python manage.py createsuperuser
```

2. Acceder a: `http://localhost:8000/admin`

## Notas de Seguridad

- Nunca subas el archivo `.env` al repositorio
- Cambia el `SECRET_KEY` en producción
- Desactiva `DEBUG=False` en producción
- Configura correctamente `ALLOWED_HOSTS`

## Dependencias Principales

- Django 4.x
- djangorestframework
- django-cors-headers
- psycopg2-binary (PostgreSQL)
- requests
- python-dotenv

## Autores

- Ian Camilo - Proyecto Final