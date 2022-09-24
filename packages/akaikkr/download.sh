#!/bin/sh
. $(dirname $0)/path.sh

if [ -f cpa2002v010.tgz ]; then :; else
  echo "cpa2002v010.tgz not found"
  exit 127
fi

tar zxf cpa2002v010.tgz
mv cpa2002v010 akaikkr_$VERSION_BASE
COPYFILE_DISABLE=1 tar zcvf akaikkr_$VERSION_BASE.orig.tar.gz --exclude ".DS_Store" akaikkr_$VERSION_BASE
rm -rf akaikkr_$VERSION_BASE
