#!/bin/bash

brew install cmake
brew install zlib
brew install protobuf
brew install snappy
brew install maven
brew install zstd
brew install cyrus-sasl
brew install isa-l
brew install bzip2
brew install openssl@1.1

export PROTOBUF_VERSION=3.7.1

curl -L https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-java-$PROTOBUF_VERSION.tar.gz | gunzip | tar -x \
 && cd protobuf-$PROTOBUF_VERSION \
 && ./configure \
 && make -j$(nproc) \
 && make install \
 && cd .. \
 && rm -fr protobuf-* \
 && ldconfig /usr/local/lib

export HADOOP_VERSION=3.3.4

curl -L https://github.com/apache/hadoop/archive/refs/tags/rel/release-$HADOOP_VERSION.tar.gz | gunzip | tar -x \
 && mv hadoop-rel-release-$HADOOP_VERSION hb \
 && cd hb \
 && export CXXFLAGS="-std=c++14" \
 && mvn package -Pdist,native -Drequire.isal -Drequire.pmdk -DskipTests -Dmaven.javadoc.skip=true -Dtar --no-transfer-progress \
 && tar xf /tmp/hb/hadoop-dist/target/hadoop-$HADOOP_VERSION.tar.gz -C /opt \
 && rm -fr /opt/hadoop-$HADOOP_VERSION/lib/native/examples \
 && ls -l  /opt/hadoop-$HADOOP_VERSION/lib/native/ \
 && sh -c '/opt/hadoop-$HADOOP_VERSION/bin/hadoop checknative -a || true' \


