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
  VERSION=$(docker images --format "{{.Tag}}" madev/"$c")
  IMAGE="madev/${c}:${VERSION}"
  echo "removing image ${IMAGE}..."
  docker rmi "$IMAGE"
done
docker volume prune -f
docker system prune -f
docker images
docker system df
