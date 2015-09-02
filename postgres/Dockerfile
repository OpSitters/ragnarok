FROM postgres:latest
MAINTAINER ops@OpsSitters.com

# Install Postgres Python packages
RUN apt-get update \
  && apt-get install -y \
    postgresql-plpython-$PG_MAJOR=$PG_VERSION \
    libpq5 \
    libdbd-pg-perl \
    libpq-dev \
  && rm -rf /var/lib/apt/lists/*

VOLUME /var/lib/postgresql/data
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]
