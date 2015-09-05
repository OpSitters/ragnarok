#!/bin/bash
[ "$1" ] && APPNAME="$1"
[ "$2" ] && ENVNAME="$2"

if [ $# -gt 2 -o "$1" = -h -o "$1" = --help -o "$2" = -h -o "$2" = --help -o $# -lt 1 ]; then
  echo "${0##*/} [Application] [VirtualENV Name] - init a new venv"
  exit 1;
fi

if [ -z $ENVNAME ]; then
  ENVNAME="${APPNAME}_env"
fi

PIP_WHEEL_DIR="${ENV_ROOT}/wheels"

ENV_PATH="${ENV_ROOT}/${ENVNAME}"
APP_DIR="${CODE_ROOT}/${APPNAME}"

PIP_REQS_FILE="${APP_DIR}/pip_requirements.txt"
PIP_BUILD_REQS_FILE="${APP_DIR}/pip_build_requirements.txt"


deactivate () {
  unset pydoc

  # reset old environment variables
  if [ -n "$_OLD_VIRTUAL_PATH" ] ; then
    PATH="$_OLD_VIRTUAL_PATH"
    export PATH
    unset _OLD_VIRTUAL_PATH
  fi
  if [ -n "$_OLD_VIRTUAL_PYTHONHOME" ] ; then
      PYTHONHOME="$_OLD_VIRTUAL_PYTHONHOME"
      export PYTHONHOME
      unset _OLD_VIRTUAL_PYTHONHOME
  fi

  # This should detect bash and zsh, which have a hash command that must
  # be called to get it to forget past commands.  Without forgetting
  # past commands the $PATH changes we made may not be respected
  if [ -n "$BASH" -o -n "$ZSH_VERSION" ] ; then
    hash -r 2>/dev/null
  fi

  if [ -n "$_OLD_VIRTUAL_PS1" ] ; then
    PS1="$_OLD_VIRTUAL_PS1"
    export PS1
    unset _OLD_VIRTUAL_PS1
  fi

  unset VIRTUAL_ENV
}


init_env () {
  rm -rf ${ENV_PATH}
  virtualenv --no-setuptools --no-pip --always-copy --no-site-packages ${ENV_PATH}
  . ${ENV_PATH}/bin/activate
  wget https://bootstrap.pypa.io/ez_setup.py -O - | ${ENV_PATH}/bin/python
  wget https://bootstrap.pypa.io/get-pip.py -O - | ${ENV_PATH}/bin/python
  rm -rf setuptools-*.zip
  deactivate
}


init_wheel () {
  . ${ENV_PATH}/bin/activate
  ${ENV_PATH}/bin/pip install wheel
  test -d ${PIP_WHEEL_DIR} || mkdir ${PIP_WHEEL_DIR}
  deactivate
}


wheel_build_reqs () {
  if test -f "${PIP_BUILD_REQS_FILE}"; then
    . ${ENV_PATH}/bin/activate
    ${ENV_PATH}/bin/pip install --download ${PIP_WHEEL_DIR} -r ${PIP_BUILD_REQS_FILE}
    for requirement in $(grep --invert-match '#' ${PIP_BUILD_REQS_FILE} | sed 's:#.*$::g'); do
      ${ENV_PATH}/bin/pip wheel --find-links=${PIP_WHEEL_DIR} --wheel-dir=${PIP_WHEEL_DIR} ${requirement}
      ${ENV_PATH}/bin/pip install --ignore-installed --use-wheel --find-links=${PIP_WHEEL_DIR} ${requirement}
    done
    ${ENV_PATH}/bin/pip wheel --find-links=${PIP_WHEEL_DIR} --wheel-dir=${PIP_WHEEL_DIR} -r ${PIP_BUILD_REQS_FILE}
    ${ENV_PATH}/bin/pip install --use-wheel --find-links=${PIP_WHEEL_DIR} -r ${PIP_BUILD_REQS_FILE}
    COUNT=0
    while [ $? -ne 0 ]; do
      (( COUNT++ ))
      if [ $COUNT -gt 2 ]; then
        echo "Yea, this shit is busted, sorry, exiting"
        exit 1
      fi
      ${ENV_PATH}/bin/pip install --use-wheel --find-links=${PIP_WHEEL_DIR} -r ${PIP_BUILD_REQS_FILE}
    done
    deactivate
  fi
}


wheel_build_all () {
  if test -f "${PIP_REQS_FILE}"; then
    . ${ENV_PATH}/bin/activate
    ${ENV_PATH}/bin/pip install --download ${PIP_WHEEL_DIR} -r ${PIP_REQS_FILE}
    ${ENV_PATH}/bin/pip wheel --find-links=${PIP_WHEEL_DIR} --wheel-dir=${PIP_WHEEL_DIR} -r ${PIP_REQS_FILE}
    ${ENV_PATH}/bin/pip install --use-wheel --find-links=${PIP_WHEEL_DIR} -r ${PIP_REQS_FILE}
    COUNT=0
    while [ $? -ne 0 ]; do
      (( COUNT++ ))
      if [ $COUNT -gt 2 ]; then
        echo "Yea, this shit is busted, sorry, exiting"
        exit 1
      fi
      ${ENV_PATH}/bin/pip wheel --find-links=${PIP_WHEEL_DIR} --wheel-dir=${PIP_WHEEL_DIR} -r ${PIP_REQS_FILE}
      ${ENV_PATH}/bin/pip install --use-wheel --find-links=${PIP_WHEEL_DIR} -r ${PIP_REQS_FILE}
    done
    deactivate
  fi
}

show_pip_packages () {
  . ${ENV_PATH}/bin/activate
  ${ENV_PATH}/bin/pip freeze
  deactivate
}


# lets do this batman!
deactivate
init_env
init_wheel
wheel_build_reqs
wheel_build_all
show_pip_packages

unset -f deactivate

