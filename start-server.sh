#!/usr/bin/env bash
set -e

LIBPATH=$1

if [[ -z "$LIBPATH" ]]; then
    echo "Path to library not given";
    exit -1;
fi

if [[ -z "$CALIBRE_USER" ]]; then
    echo "Variable CALIBRE_USER is not set";
    exit -1;
fi
if [[ -z "$CALIBRE_PASS" ]]; then
    echo "Variable CALIBRE_PASS is not set";
    exit -1;
fi
sed -i "s/set USER placeholder/set USER $CALIBRE_USER/" adduser.ex
sed -i "s/set PASSWORD placeholder/set PASSWORD $CALIBRE_PASS/" adduser.ex
./adduser.ex

./calibredb list --with-library="$LIBPATH"

./calibre-server --enable-auth --userdb users.sqlite --disable-use-bonjour --ban-after=5 --ban-for=5 "$LIBPATH"
