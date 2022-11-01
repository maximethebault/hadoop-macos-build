#!/bin/bash

set -e

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

curl -L https://github.com/apache/hadoop/archive/refs/tags/rel/release-$HADOOP_VERSION.tar.gz | gunzip | tar -x
mv hadoop-rel-release-$HADOOP_VERSION hb
cd hb
# don't ignore ZLIB_ROOT
sed -i '' -e "24s/^//p; 24s/^.*/cmake_policy(SET CMP0074 NEW)/" hadoop-common-project/hadoop-common/src/CMakeLists.txt
# don't ignore OPENSSL_ROOT
sed -i '' -e "23s/^//p; 23s/^.*/cmake_policy(SET CMP0074 NEW)/" hadoop-hdfs-project/hadoop-hdfs-native-client/src/CMakeLists.txt
# yarn project doesn't inherit CFLAGS, do it manually
#sed -i '' -e '39s/^//p; 39s/^.*/SET (CMAKE_C_FLAGS "-Wno-error=implicit-function-declaration ${CMAKE_C_FLAGS}")/' hadoop-yarn-project/hadoop-yarn/hadoop-yarn-server/hadoop-yarn-server-nodemanager/src/CMakeLists.txt
# get rid of glib version check not working on MacOS
sed -i '' 's/ || defined(__GLIBC_PREREQ) && __GLIBC_PREREQ(2, 32)//' hadoop-common-project/hadoop-common/src/main/native/src/exception.c
# output the modified file for debug
#cat hadoop-common-project/hadoop-common/src/CMakeLists.txt
mvn package -Pdist,native -Drequire.zstd -Drequire.openssl -Dopenssl.prefix="$OPENSSL_ROOT_DIR" -Dopenssl.lib="$OPENSSL_LIB_DIR" -Dopenssl.include="$OPENSSL_INCLUDE_DIR" -DskipTests -Dmaven.javadoc.skip=true -Dtar --no-transfer-progress
cd ..
tar xf hb/hadoop-dist/target/hadoop-$HADOOP_VERSION.tar.gz -C .
rm -fr hadoop-$HADOOP_VERSION/lib/native/examples
ls -l  hadoop-$HADOOP_VERSION/lib/native/
sh -c 'hadoop-$HADOOP_VERSION/bin/hadoop checknative -a || true'


