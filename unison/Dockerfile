FROM ragnarok/unison
MAINTAINER ops@OpsSitters.com

ENV APP_USER ragnarok
ENV APP_GROUP staff

# Add the user that docker runs as
RUN useradd -r -m -N \
  -s /bin/bash \
  -u 1000 \
  -g ${APP_GROUP} ${APP_USER}

COPY unison-sync.sh /usr/local/sbin/uni-sync

# Default command is sync locally, use the following to start in daemon mode
#CMD ["/sbin/my_init"]

CMD ["/usr/local/sbin/uni-sync"]

VOLUME /dummy

EXPOSE 5000
