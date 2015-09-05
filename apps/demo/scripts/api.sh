#!/bin/bash

RDSCHECK='test "$(redis-cli -h redis ping)" == "PONG"'


svc_ready() {
  eval "$RDSCHECK"
}

i=0
while ! svc_ready; do
  i=`expr $i + 1`
  if [ $i -ge $SVC_TRY ]; then
    echo "ERROR: $(date) - services never came up"
    exit 1
  fi
  sleep $SVC_WAIT
done

cd /${CODE_ROOT}/demo
test -f /${ENV_ROOT}/demo/bin/activate || /scripts/env_update.sh
source /${ENV_ROOT}/demo/bin/activate
exec python app.py
