#!/usr/bin/env bash

VERSION=$1
MINOR=$(echo ${VERSION} | cut -d. -f1,2)

set -ex

wget -O "python.tar.xz" "https://www.python.org/ftp/python/${VERSION}/Python-${VERSION}.tar.xz" \
    && mkdir -p /usr/src/python \
    && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz \
    && rm python.tar.xz \
    && cd /usr/src/python \
    && ./configure \
    && make \
    && make install \
    && find /usr/local -depth \
		\( \
			\( -type d -a \( -name test -o -name tests \) \) \
			-o \
			\( -type f -a \( -name "*.pyc" -o -name "*.pyo" \) \) \
		\) -exec rm -rf "{}" + \
	&& rm -rf /usr/src/python \
    && "python${MINOR}" --version
