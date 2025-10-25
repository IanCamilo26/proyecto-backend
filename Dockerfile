FROM python:3.13-slim

WORKDIR /app

# instalar netcat para que el script wait-for-db.sh pueda verificar la base de datos
RUN apt-get update \
  && apt-get install -y --no-install-recommends netcat-openbsd \
  && rm -rf /var/lib/apt/lists/*

# copiamos únicamente el script de espera
COPY wait-for-db.sh /wait-for-db.sh
RUN chmod +x /wait-for-db.sh

# comando por defecto: esperar a la base de datos
CMD ["/wait-for-db.sh", "db:5432", "--", "echo", "PostgreSQL está listo"]