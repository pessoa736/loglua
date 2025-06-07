# esse dockerfile é só para rodar os scripts para test
FROM nickblah/lua:5.4-noble


COPY ./src /src
COPY ./test /test

WORKDIR /src