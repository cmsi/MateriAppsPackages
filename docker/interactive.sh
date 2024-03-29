#!/bin/sh

SCRIPT="$0"
SCRIPT_DIR=$(cd $(dirname ${SCRIPT}) && pwd)

CODENAME="$1"
if [ -z ${CODENAME} ]; then
  CODENAME="trixie"
fi

. $SCRIPT_DIR/../config/version.sh
for v in ${VERSIONS}; do
  if [ $(echo ${v} | cut -d/ -f1) = ${CODENAME} ]; then
    LABEL=$(echo ${v} | cut -d: -f2)
  fi
done

D_USERNAME=$(id -un)
D_HOME=/home/${D_USERNAME}

if [ -d "${HOME}/.ssh-docker" ]; then
  SSH_CONFIG="-v ${HOME}/.ssh-docker:${D_HOME}/.ssh:ro"
elif [ -d "${HOME}/.ssh" ]; then
  SSH_CONFIG="-v ${HOME}/.ssh:${D_HOME}/.ssh:ro"
fi

if [ -d "${HOME}/share" ]; then
  SHARE_CONFIG="-v ${HOME}/share:${D_HOME}/share"
fi

if [ -d "${HOME}/development" ]; then
  DEV_CONFIG="-v ${HOME}/development:${D_HOME}/development"
fi

if [ -d "${HOME}/.config/git" ]; then
  GIT_CONFIG="-v ${HOME}/.config/git:${D_HOME}/.config/git:ro"
elif [ -f "${HOME}/.gitconfig" ]; then
  GIT_CONFIG="-v ${HOME}/.gitconfig:${D_HOME}/.gitconfig:ro"
fi

if [ -f "${SCRIPT_DIR}/dot.quiltrc" ]; then
  QUILT_CONFIG="-v ${SCRIPT_DIR}/dot.quiltrc:${D_HOME}/.quiltrc:ro"
fi

if [ -n "${MALIVE_DATA_DIR}" ]; then
  DATA_CONFIG="-e DATA_DIR=${MALIVE_DATA_DIR}"
fi

echo "starting ${CODENAME}"
IMAGE="madev/${CODENAME}:${LABEL}"
ID_U=$(id -u)
ID_G=$(id -g)
set -x
docker run --rm -it --detach-keys='ctrl-e,e' --name $CODENAME.$$ --user ${ID_U}:${ID_G} -e DISPLAY=host.docker.internal:0 -v madev-vol:${D_HOME} ${DATA_CONFIG} ${SSH_CONFIG} ${SHARE_CONFIG} ${DEV_CONFIG} ${GIT_CONFIG} ${QUILT_CONFIG} ${IMAGE} /bin/bash
