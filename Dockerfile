FROM python:3.9-slim

WORKDIR /app

COPY . .

RUN pip install --no-cache-dir -r requirements.txt

ENV FLASK_ENV=development
ENV FLASK_APP=run.py
ENV FLASK_DB_TYPE=postgres
ENV FLASK_DB_USER=postgres
ENV FLASK_DB_NAME=postgres
ENV FLASK_DB_PASSWORD=secretpass
ENV FLASK_DB_HOST=localhost
ENV FLASK_DB_PORT=30543

EXPOSE 5000

CMD  ["flask", "run",  "--host=0.0.0.0", "--port=5000"]
