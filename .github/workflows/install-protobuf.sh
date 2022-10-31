#!/bin/bash

set -e

cd protobuf
make install
brew link protobuf
cd ..
