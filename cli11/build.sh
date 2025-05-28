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

wget https://github.com/CLIUtils/CLI11/archive/refs/tags/v2.5.0.zip
unzip v2.5.0.zip
cd CLI11-2.5.0

mkdir build; cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local -D CMAKE_INSTALL_LIBDIR=/usr/local/lib -D BUILD_SHARED_LIBS=ON -G Ninja ..
ninja

ninja test || exit 1

DESTDIR="$DESTDIR" ninja install

cd ../..

../_dev/generate_sqfs.sh cli11

rm -Rf "$DESTDIR" v2.5.0.zip CLI11-2.5.0
