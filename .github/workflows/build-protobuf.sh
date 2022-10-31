#!/bin/bash

curl -L https://github.com/protocolbuffers/protobuf/releases/download/v$PROTOBUF_VERSION/protobuf-java-$PROTOBUF_VERSION.tar.gz | gunzip | tar -x
mv protobuf-$PROTOBUF_VERSION protobuf
cd protobuf
./configure --prefix=/usr/local/Cellar/protobuf/$PROTOBUF_VERSION
make -j$(nproc)
cd ..

