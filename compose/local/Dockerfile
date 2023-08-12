FROM python:3.8-alpine as base

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

COPY /requirements /requirements

RUN apk update && apk upgrade \
    && apk add --virtual build-deps gcc python3-dev musl-dev \
    && apk add --no-cache mariadb-dev mysql-client libmagic libffi-dev curl vim \
    && python -m pip install --upgrade pip \
    && pip install -r /requirements/local.txt \
    && apk del build-deps

FROM base as api
COPY compose/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN ln -s /usr/local/bin/entrypoint.sh / # backwards compat

COPY compose/wait-for /usr/local/bin/
RUN chmod +x /usr/local/bin/wait-for
RUN ln -s /usr/local/bin/wait-for / # backwards compat

COPY compose/start-app.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-app.sh
RUN ln -s /usr/local/bin/start-app.sh / # backwards compat

WORKDIR /src
ADD . /src/
ENTRYPOINT ["/entrypoint.sh"]


FROM base as worker
COPY compose/celery/worker/start-celery-worker.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-celery-worker.sh
RUN ln -s /usr/local/bin/start-celery-worker.sh / # backwards compat

WORKDIR /src
ADD . /src/

FROM base as beat
COPY compose/celery/beat/start-celery-beat.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-celery-beat.sh
RUN ln -s /usr/local/bin/start-celery-beat.sh / # backwards compat

WORKDIR /src
ADD . /src/