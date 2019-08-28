#brainstorm-web
FROM python:2.7-alpine
RUN apk update
RUN apk add --no-cache gcc musl-dev linux-headers postgresql-dev python3-dev py-psycopg2 postgresql-client
COPY . /flask
WORKDIR /flask
ENV FLASK_APP run.py
ENV FLASK_RUN_HOST 0.0.0.0
ENV FLASK_ENV development
RUN pip install -r requirements.txt
CMD ["python","run.py"]
