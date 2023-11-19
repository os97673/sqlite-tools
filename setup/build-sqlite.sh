#!/bin/sh
set -e
# source: https://developer.android.com/reference/android/database/sqlite/package-summary
# and manually added recent versions 3.39.2 (api 34)
SQLITE_VERSIONS="3.8.0 3.9.0 3.18.0 3.19.0 3.22.0 3.28.0 3.32.0 3.39.2 3.43.2"
SQLITE_SRC=$1
BINARIES=$2
CURRENT_DIR=`pwd`
echo $SQLITE_SRC
echo $BINARIES
mkdir -p $BINARIES
cd $SQLITE_SRC
echo "Updting sources"
git pull
echo Building...
for SQLITE_VERSION in $SQLITE_VERSIONS; do
    echo $SQLITE_VERSION
    BINARY_DIR=$BINARIES/$SQLITE_VERSION
    if [ -f $BINARY_DIR/sqlite3 ]; then
        echo exists
    else
        echo building
        git clean -dfx
        git co version-$SQLITE_VERSION
        CPPFLAGS="-DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS"  ./configure --prefix $BINARY_DIR
        make -j16
        rm -rf $BINARY_DIR
        mkdir -p $BINARY_DIR
        make install
        #cp -R .libs $BINARY_DIR/.libs
        #cp sqlite3 $BINARY_DIR/sqlite3
    fi
done
git clean -dfx
cd $CURRENT_DIR
