FROM python:2.7
MAINTAINER ops@OpsSitters.com

ENV RAGNAROK true
ENV CODE_ROOT /shared
ENV ENV_ROOT /envs

ENV PHANTOM_VER 1.9.7
ENV CASPER_VER 1.1-beta3

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl wget ca-certificates openssh-client locales \
  && rm -rf /var/lib/apt/lists/* \
  && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# Database clients
RUN \
  apt-get update && apt-get install -y --no-install-recommends \
    redis-tools \
  && rm -rf /var/lib/apt/lists/*

# Shell Tools
RUN \
  apt-get update && apt-get install -y --no-install-recommends \
    strace vim \
  && rm -rf /var/lib/apt/lists/*

# Clean up, Clean up, every body every where!
RUN apt-get clean \
  && cd /var/lib/apt/lists && rm -fr *Release* *Sources* *Packages* \
  && truncate -s 0 /var/log/*log

# https://github.com/docker/docker/issues/4032
ENV DEBIAN_FRONTEND screenSize

# Copy our scripts
ADD scripts /scripts
RUN chmod 755 /scripts/*

# Configure the User
COPY user/.bashrc /root/.bashrc
COPY user/ssh_config /etc/ssh/ssh_config

# Make Some links!
RUN \
  ln -s /scripts/init_env.sh /usr/local/bin/init_env && \
  ln -s ${CODE_ROOT} /root/code

RUN pip install --no-cache-dir virtualenvwrapper

WORKDIR ${CODE_ROOT}
