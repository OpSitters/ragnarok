if [ -n "$ZSH_VERSION" ]; then
  RAGNAROK_DIR=${0:a:h}
elif [ -n "$BASH_VERSION" ]; then
  RAGNAROK_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
else
  RAGNAROK_DIR=$(dirname $0)
fi

export RAGNAROK_DIR=$RAGNAROK_DIR

source $RAGNAROK_DIR/.exports
source $RAGNAROK_DIR/controllers/ragnarok
source $RAGNAROK_DIR/controllers/log
source $RAGNAROK_DIR/controllers/postgres

for app in $(ls -d $RAGNAROK_APP_DIR/*); do
  if [ -f $app/controller ]; then
    source $app/controller
  fi
done