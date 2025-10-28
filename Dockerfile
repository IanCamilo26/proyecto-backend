# proyecto-backend/Dockerfile
FROM python:3.13-slim AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Dependencias del sistema necesarias (solo lo mínimo)
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      libpq-dev \
      netcat-openbsd \
    && python -m pip install --upgrade pip \
    && rm -rf /var/lib/apt/lists/*

# Dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiamos el código
COPY . .

# Crear usuario no-root
RUN useradd --create-home appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

# Entrypoint: espera DB (opcional en dev), ejecuta migraciones y arranca gunicorn (ASGI)
# Ajustá 'project.asgi:application' por tu módulo ASGI real si difiere.
CMD ["sh", "-c", "python manage.py migrate --noinput && exec gunicorn backend.asgi:application -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:8000 --workers 2 --threads 2 --timeout 120"]
