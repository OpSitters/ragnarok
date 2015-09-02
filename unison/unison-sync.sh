#!/bin/sh
export HOME=/root
cd /unison/
UNISON_OPTS="-numericids -group"


# FS Helper
if [ -f /bin/unison-$UNISON_VERSION-fsmonitor ]; then
  ln -s -f /bin/unison-$UNISON_VERSION-fsmonitor /bin/unison-fsmonitor
fi

if [ -z $1 ]; then
  if [ -z $SYNC_TYPE ]; then
    # Sync this shit (locally) yo
    exec unison-${UNISON_VERSION} ${SYNC_MOUNT} . -auto ${UNISON_OPTS} -repeat watch -terse -ignore 'Name {*.pyc,.git,*.swp}'
  else
    echo "Launching unison-${UNISON_VERSION} from $(pwd) as ${SYNC_TYPE}"
    exec unison-${UNISON_VERSION} -socket 5000 -auto -ignore 'Name {*.pyc,.git,*.swp}'
  fi
else
  # Initial sync
  exec unison-${UNISON_VERSION} . /unison/ -auto ${UNISON_OPTS} -batch -ignore 'Name {*.pyc,.git,*.swp}'
fi
