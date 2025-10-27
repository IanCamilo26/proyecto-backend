FROM python:3.13-slim

WORKDIR /app

# instalar utilidades del sistema necesarias (netcat; libpq-dev y build-essential
# sólo si usás psycopg2 no-binary)
RUN apt-get update \
  && apt-get install -y --no-install-recommends netcat-openbsd \
  && python -m pip install --upgrade pip \
  && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

EXPOSE 8000

RUN chmod +x ./wait-for.sh

CMD ["./wait-for.sh", "db:5432", "--", "sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]
