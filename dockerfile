# esse dockerfile é só para rodar os scripts para test
FROM nickblah/lua:5.4.7

RUN mkdir /log_lib

COPY ./src /logs_lib/src
COPY ./test /log_lib/test

WORKDIR /log_lib