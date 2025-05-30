#!/bin/sh

NEEDED=

DESTDIR="$PWD/_install"

../_dev/build_common.sh

for i in compiletc squashfs-tools zsync ninja cmake clang
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

# clang needs to be IN /usr/local/bin, not just symlinked
if [ "$(readlink /usr/local/bin/clang-19)" != "" ]
then
	sudo rm -f /usr/local/bin/clang-19
	sudo cp /tmp/tcloop/clang/usr/local/bin/clang-19 /usr/local/bin
fi

# Make sure the symlinks point to the correct executable
if [ "$(readlink /usr/local/bin/clang)" != "clang-19" ]
then
	sudo ln -sf clang-19 /usr/local/bin/clang
	sudo ln -sf clang-19 /usr/local/bin/clang++
fi

mkdir "$DESTDIR"

wget https://github.com/microsoft/GSL/archive/refs/tags/v4.2.0.tar.gz
tar -xvf v4.2.0.tar.gz
cd GSL-4.2.0
mkdir build; cd build
cmake -D CMAKE_C_COMPILER=/usr/local/bin/clang -D CMAKE_CXX_COMPILER=/usr/local/bin/clang++ \
      -D CMAKE_C_FLAGS_RELEASE="-flto -mtune=generic -Os -pipe" \
      -D CMAKE_CXX_FLAGS_RELEASE="-flto -mtune=generic -Os -pipe" \
      -D CMAKE_INSTALL_PREFIX=/usr/local -D CMAKE_INSTALL_LIBDIR=/usr/local/lib \
      -D BUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release ..

make

DESTDIR="$DESTDIR" make install

cd ../..

../_dev/generate_sqfs.sh GSL

rm -Rf "$DESTDIR" v4.2.0.tar.gz GSL-4.2.0
