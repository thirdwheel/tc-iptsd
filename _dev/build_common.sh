#!/bin/sh

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

