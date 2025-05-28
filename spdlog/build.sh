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

wget https://github.com/gabime/spdlog/archive/refs/tags/v1.15.3.zip
unzip v1.15.3.zip
cd spdlog-1.15.3

mkdir build; cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local -D CMAKE_INSTALL_LIBDIR=/usr/local/lib -D BUILD_SHARED_LIBS=ON .. || exit 1
cmake --build .
DESTDIR="$DESTDIR" make install

cd ../..

for i in "" -dev
do
	../_dev/generate_sqfs.sh spdlog$i
done

rm -Rf "$DESTDIR" spdlog-1.15.3 v1.15.3.zip
