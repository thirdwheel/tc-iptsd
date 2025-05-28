#!/bin/sh

NEEDED=

DESTDIR="$PWD/_install"

case $(uname -m) in
	x86) export CFLAGS="-march=i486 -mtune=i486 -Os -pipe"
	     export CXXFLAGS="-march=i486 -mtune=i486 -Os -pipe"
	     export LDFLAGS="-Wl,-O1"
	     ;;
	x86_64) export CFLAGS="-mtune=generic -Os -pipe"
		export CXXFLAGS="-mtune=generic -Os -pipe"
		export LDFLAGS="-Wl,-O1"
		;;
esac

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

wget https://github.com/fmtlib/fmt/archive/11.2.0/fmt-11.2.0.tar.gz
tar -xvf fmt-11.2.0.tar.gz
cd fmt-11.2.0

mkdir build; cd build
cmake -D CMAKE_INSTALL_PREFIX=/usr/local -D CMAKE_INSTALL_LIBDIR=/usr/local/lib -D BUILD_SHARED_LIBS=ON -D FMT_TEST=OFF -G Ninja ..
ninja
DESTDIR="$DESTDIR" ninja install

cd ../..

for i in "" -dev
do
	../_dev/generate_sqfs.sh fmt$i
done

rm -Rf "$DESTDIR" fmt-11.2.0*
