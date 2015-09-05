#!/bin/bash

APPNAME=demo
ENVNAME=demo

APP_DIR="${CODE_ROOT}/${APPNAME}"
ENV_DIR="${ENV_ROOT}/${ENVNAME}"

PIP_WHEEL_DIR="${ENV_ROOT}/wheels"
PIP_REQS_FILE="${APP_DIR}/pip_requirements.txt"


if test -d ${ENV_DIR}; then
  . ${ENV_DIR}/bin/activate
  ${ENV_DIR}/bin/pip install --download ${PIP_WHEEL_DIR} -r ${PIP_REQS_FILE}
  ${ENV_DIR}/bin/pip wheel --find-links=${PIP_WHEEL_DIR} --wheel-dir=${PIP_WHEEL_DIR} -r ${PIP_REQS_FILE}
  exec ${ENV_DIR}/bin/pip install --use-wheel --find-links=${PIP_WHEEL_DIR} -r ${PIP_REQS_FILE}
else
  exec init_env demo demo
fi
