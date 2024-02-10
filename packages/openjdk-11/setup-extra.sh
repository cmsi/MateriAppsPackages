#!/bin/sh

URL=http://ftp.jp.debian.org/debian/pool/main/o/openjdk-11
ARCH=$(dpkg --print-architecture)
VERSION="11.0.22+7-2"

if [ -f /usr/lib/jvm/java-11-openjdk-${ARCH}/bin/javac ]; then :; else
  sudo apt-get -y install ca-certificates-java java-common libcups2 liblcms2-2 libnss3 libasound2 libharfbuzz0b libpcsclite1 libasound2-data libavahi-client3 libavahi-common3 libgraphite2-3 libavahi-common-data libnspr4 libdbus-1-3
  for d in openjdk-11-jre-headless_${VERSION}_${ARCH}.deb openjdk-11-jdk-headless_${VERSION}_${ARCH}.deb; do
    wget ${URL}/${d}
    sudo dpkg -i ${d}
    rm -f ${d}
  done
fi
