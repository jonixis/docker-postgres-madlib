FROM postgres:11.5-alpine

RUN apk update                   && \
    apk --no-cache add --update     \
        build-base \
        m4 \
        patch \
        cmake \
        python \
        py-pip \
        postgresql-plpython2     && \
    pip install pgxnclient       && \
    pgxn install madlib          && \
    ln -s /usr/lib/postgresql/plpython2.so /usr/local/lib/postgresql/plpython2.so && \
    ln -s /usr/share/postgresql/extension/plpython2u.control /usr/local/share/postgresql/extension/plpython2u.control && \
    ln -s /usr/share/postgresql/extension/plpython2u--1.0.sql /usr/local/share/postgresql/extension/plpython2u--1.0.sql && \
    ln -s /usr/share/postgresql/extension/plpython2u--unpackaged--1.0.sql /usr/local/share/postgresql/extension/plpython2u--unpackaged--1.0.sql && \
    ln -s /usr/share/postgresql/extension/plpythonu--unpackaged--1.0.sql /usr/local/share/postgresql/extension/plpythonu--unpackaged--1.0.sql && \
    ln -s /usr/share/postgresql/extension/plpythonu.control /usr/local/share/postgresql/extension/plpythonu.control && \
    ln -s /usr/share/postgresql/extension/plpythonu--1.0.sql /usr/local/share/postgresql/extension/plpythonu--1.0.sql

COPY admission_table.csv /tmp/
COPY admission.sql /docker-entrypoint-initdb.d/
COPY load_extensions.sh /docker-entrypoint-initdb.d/
