#!/bin/sh

SCRIPT="$0"
SCRIPT_DIR=$(cd $(dirname ${SCRIPT}) && pwd)

INCLUDE_SOURCE=0
if [ "$1" = "-sa" ]; then
  INCLUDE_SOURCE=1
  shift
fi
APP="$1"; shift
CODENAMES="$*"

if [ -z ${APP} ]; then
  echo "Usage: ${SCRIPT} [-sa] app [codename...]"
  exit 127
fi

. $SCRIPT_DIR/config/version.sh
if [ -z "${CODENAMES}" ]; then
  for v in ${VERSIONS}; do
    CODENAMES="${CODENAMES} $(echo ${v} | cut -d/ -f1)"
  done
fi

if [ -z ${MALIVE_DATA_DIR} ]; then
  echo "Error: environment variable MALIVE_DATA_DIR not defined"
  exit 127
fi

ENV_CONFIG="--env DATA_DIR=${MALIVE_DATA_DIR} --env MA_INCLUDE_SOURCE=${INCLUDE_SOURCE}"
D_USERNAME=$(id -un)
D_HOME=/home/${D_USERNAME}

if [ -d "${HOME}/.ssh-docker" ]; then
  SSH_CONFIG="-v ${HOME}/.ssh-docker:${D_HOME}/.ssh:ro"
elif [ -d "${HOME}/.ssh" ]; then
  SSH_CONFIG="-v ${HOME}/.ssh:${D_HOME}/.ssh:ro"
fi

if [ -d "${HOME}/.config/git" ]; then
  GIT_CONFIG="-v ${HOME}/.config/git:${D_HOME}/.config/git:ro"
elif [ -f "${HOME}/.gitconfig" ]; then
  GIT_CONFIG="-v ${HOME}/.gitconfig:${D_HOME}/.gitconfig:ro"
fi

for c in ${CODENAMES}; do
  echo "building ${APP} for ${c}..."
  IMAGE="madev/${c}"
  ID_U=$(id -u)
  ID_G=$(id -g)
  set -x
  docker run --rm --name ${c}.$$ --user ${ID_U}:${ID_G} ${ENV_CONFIG} ${SSH_CONFIG} ${GIT_CONFIG} ${IMAGE} /bin/bash -c "rm -rf MateriAppsPackages && git clone https://github.com/cmsi/MateriAppsPackages.git && sh MateriAppsPackages/script/setup.sh ${APP} && sh MateriAppsPackages/script/build.sh ${APP}"
  set +x
done
