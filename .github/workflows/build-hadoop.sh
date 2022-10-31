#!/bin/bash

export HADOOP_VERSION=3.3.4
export OPENSSL_ROOT_DIR="/usr/local/opt/openssl@1.1"
export OPENSSL_INCLUDE_DIR="$OPENSSL_ROOT_DIR/include"
export PKG_CONFIG_PATH="${OPENSSL_ROOT_DIR}/lib/pkgconfig"

curl -L https://github.com/apache/hadoop/archive/refs/tags/rel/release-$HADOOP_VERSION.tar.gz | gunzip | tar -x \
 && mv hadoop-rel-release-$HADOOP_VERSION hb \
 && cd hb \
 && export CXXFLAGS="-std=c++14" \
 && mvn package -Pdist,native -Drequire.isal -Drequire.pmdk -DskipTests -Dmaven.javadoc.skip=true -Dtar --no-transfer-progress \
 && tar xf /tmp/hb/hadoop-dist/target/hadoop-$HADOOP_VERSION.tar.gz -C /opt \
 && rm -fr /opt/hadoop-$HADOOP_VERSION/lib/native/examples \
 && ls -l  /opt/hadoop-$HADOOP_VERSION/lib/native/ \
 && sh -c '/opt/hadoop-$HADOOP_VERSION/bin/hadoop checknative -a || true' \


