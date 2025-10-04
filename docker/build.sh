#!/bin/sh

SCRIPT="$0"
SCRIPT_DIR=$(cd $(dirname ${SCRIPT}) && pwd)

CODENAMES="$1"

. $SCRIPT_DIR/../config/version.sh
if [ -z "${CODENAMES}" ]; then
  for v in ${VERSIONS}; do
    CODENAMES="${CODENAMES} $(echo ${v} | cut -d/ -f1)"
  done
fi

for c in ${CODENAMES}; do
  for v in ${VERSIONS}; do
    if [ $(echo ${v} | cut -d/ -f1) = ${c} ]; then
      BASE=$(echo ${v} | cut -d/ -f2)
      LABEL=$(echo ${v} | cut -d: -f2)
      IMAGE="madev/${c}"
      echo "building image ${IMAGE} from ${BASE}..."
      docker build -t ${IMAGE}:${LABEL} - <<EOF
FROM ${BASE}
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq \
 && apt-get -y upgrade \
 && apt-get -y install \
      build-essential \
      cdbs \
      cmake \
      curl \
      debhelper \
      devscripts \
      dh-cmake \
      gfortran \
      git \
      liblapack-dev \
      mpi-default-dev \
      quilt \
      sudo \
      vim \
      wget \
 && curl -L https://malive.s3.amazonaws.com/repos/setup.sh | /bin/sh \
 && apt-get update \
 && echo "unalias ls" >> /etc/skel/.bashrc

ARG USERNAME=$(id -un)
ARG GROUPNAME=$(id -gn)
ARG UID=$(id -u)
ARG GID=$(id -g)
RUN groupadd -f -g \$GID \$GROUPNAME \
 && useradd -m -s /bin/bash -u \$UID -g \$GID -G sudo \$USERNAME \
 && echo \$USERNAME:live | chpasswd \
 && echo "\$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER \$USERNAME
WORKDIR /home/\$USERNAME/
EOF
    fi
  done
done
docker images
docker system df
