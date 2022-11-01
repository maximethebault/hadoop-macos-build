#!/bin/bash

set -e

# AT EACH NEW HADOOP RELEASE, UPDATE THE HARDCODED LINE NUMBERS WHEN EDITING SOURCE FILES

export ZLIB_ROOT=/usr/local/Cellar/zlib/1.2.13
export OPENSSL_ROOT_DIR="/usr/local/Cellar/openssl@1.1/1.1.1q"
export OPENSSL_LIBRARIES="$OPENSSL_ROOT_DIR/lib"
export OPENSSL_LIB_DIR="$OPENSSL_ROOT_DIR/lib"
export OPENSSL_INCLUDE_DIR="$OPENSSL_ROOT_DIR/include"
export PKG_CONFIG_PATH="${OPENSSL_ROOT_DIR}/lib/pkgconfig"
#export CFLAGS="-Wno-error=implicit-function-declaration"
export CC=$(which gcc-10)
export CXX=$(which g++-10)
export CPP=$(which cpp-10)
export LD=$(which gcc-10)
#export CXXFLAGS="-std=c++14"

curl -L "https://github.com/maximethebault/hadoop/archive/refs/heads/branch-$HADOOP_VERSION.zip" -o hadoop.zip
unzip -q hadoop.zip
rm hadoop.zip
mv "hadoop-branch-$HADOOP_VERSION" hb
cd hb
mvn package -Pdist,native -Drequire.zstd -Drequire.openssl -Dopenssl.prefix="$OPENSSL_ROOT_DIR" -Dopenssl.lib="$OPENSSL_LIB_DIR" -Dopenssl.include="$OPENSSL_INCLUDE_DIR" -DskipTests -Dmaven.javadoc.skip=true -Dtar --no-transfer-progress
cd ..
tar xf hb/hadoop-dist/target/hadoop-$HADOOP_VERSION.tar.gz -C .
rm -fr hadoop-$HADOOP_VERSION/lib/native/examples
ls -l  hadoop-$HADOOP_VERSION/lib/native/
sh -c 'hadoop-$HADOOP_VERSION/bin/hadoop checknative -a || true'


