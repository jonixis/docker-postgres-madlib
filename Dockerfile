FROM postgres:11.5-alpine


RUN apk update && apk --no-cache add --update \
      build-base \
      m4 \
      patch \
      cmake \
      python \
      py-pip \
      postgresql-plpython2 \
      libc6-compat \
  && pip install pgxnclient \
  && pgxn install madlib \
  && wget -O /usr/local/bin/pgfutter https://github.com/lukasmartinelli/pgfutter/releases/download/v1.2/pgfutter_linux_amd64 \
  && chmod +x /usr/local/bin/pgfutter \
  && ln -s /usr/lib/postgresql/plpython2.so /usr/local/lib/postgresql/plpython2.so \
  && ln -s /usr/share/postgresql/extension/plpython2u.control /usr/local/share/postgresql/extension/plpython2u.control \
  && ln -s /usr/share/postgresql/extension/plpython2u--1.0.sql /usr/local/share/postgresql/extension/plpython2u--1.0.sql \
  && ln -s /usr/share/postgresql/extension/plpython2u--unpackaged--1.0.sql /usr/local/share/postgresql/extension/plpython2u--unpackaged--1.0.sql \
  && ln -s /usr/share/postgresql/extension/plpythonu--unpackaged--1.0.sql /usr/local/share/postgresql/extension/plpythonu--unpackaged--1.0.sql \
  && ln -s /usr/share/postgresql/extension/plpythonu.control /usr/local/share/postgresql/extension/plpythonu.control \
  && ln -s /usr/share/postgresql/extension/plpythonu--1.0.sql /usr/local/share/postgresql/extension/plpythonu--1.0.sql

COPY admission_table.csv /tmp/
COPY rhc.csv /tmp/

COPY admission.sql /docker-entrypoint-initdb.d/
COPY setup.sh /docker-entrypoint-initdb.d/
