#!/bin/bash

set -e

ls -R "/usr/local/Cellar/openssl@1.1/"
ls -R "/usr/local/opt/openssl/"

export ZLIB_ROOT=/usr/local/Cellar/zlib/1.2.13
export OPENSSL_ROOT_DIR="/usr/local/opt/openssl"
export OPENSSL_INCLUDE_DIR="$OPENSSL_ROOT_DIR/include"
export PKG_CONFIG_PATH="${OPENSSL_ROOT_DIR}/lib/pkgconfig"
export CXXFLAGS="-std=c++14"

curl -L https://github.com/apache/hadoop/archive/refs/tags/rel/release-$HADOOP_VERSION.tar.gz | gunzip | tar -x
mv hadoop-rel-release-$HADOOP_VERSION hb
cd hb
# don't ignore ZLIB_ROOT
sed -i '' -e "24s/^//p; 24s/^.*/cmake_policy(SET CMP0074 NEW)/" hadoop-common-project/hadoop-common/src/CMakeLists.txt
# get rid of glib version check not working on MacOS
sed -i '' 's/ || defined(__GLIBC_PREREQ) && __GLIBC_PREREQ(2, 32)//' hadoop-common-project/hadoop-common/src/main/native/src/exception.c
# output the modified file for debug
cat hadoop-common-project/hadoop-common/src/CMakeLists.txt
mvn package -Pdist,native -Drequire.zstd -Drequire.openssl -Dopenssl.prefix="$OPENSSL_ROOT_DIR" -DskipTests -Dmaven.javadoc.skip=true -Dtar --no-transfer-progress
cd ..
tar xf hb/hadoop-dist/target/hadoop-$HADOOP_VERSION.tar.gz -C .
rm -fr hadoop-$HADOOP_VERSION/lib/native/examples
ls -l  hadoop-$HADOOP_VERSION/lib/native/
sh -c 'hadoop-$HADOOP_VERSION/bin/hadoop checknative -a || true'


