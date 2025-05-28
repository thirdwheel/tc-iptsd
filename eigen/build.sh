#!/bin/sh

NEEDED=

DESTDIR="$PWD/_install"

../_dev/build_common.sh

for i in compiletc squashfs-tools zsync ninja cmake
do
	if [ ! -f /usr/local/tce.installed/$i ]
	then
		NEEDED="$NEEDED $i"
	fi
done

if [ "$NEEDED" ]
then
	tce-load -wi $NEEDED
fi

mkdir "$DESTDIR"

wget https://gitlab.com/libeigen/eigen/-/archive/3.4/eigen-3.4.tar.gz
tar -zxf eigen-3.4.tar.gz
cd eigen-3.4

mkdir build; cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local -D CMAKE_INSTALL_LIBDIR=/usr/local/lib -D BUILD_SHARED_LIBS=ON .. || exit 1
DESTDIR="$DESTDIR" make install

cd ../..

../_dev/generate_sqfs.sh eigen

rm -Rf "$DESTDIR" eigen-3.4*
