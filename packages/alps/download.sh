#!/bin/sh
. $(dirname $0)/path.sh

REVISION=$(echo ${VERSION_BASE} | cut -dr -f2)
URL=https://alps.comp-phys.org/svn/alps1/trunk/alps

if [ -f alps_${VERSION_BASE}.orig.tar.gz ]; then
  exit 127
fi
rm -rf alps-${VERSION_BASE}
svn export -r ${REVISION} ${URL} alps-${VERSION_BASE}
tar zcvf alps_${VERSION_BASE}.orig.tar.gz alps-${VERSION_BASE}
rm -rf alps-${VERSION_BASE}
