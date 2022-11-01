#!/bin/bash

set -e

export CC=$(which gcc-10)
export CXX=$(which g++-10)
export CPP=$(which cpp-10)
export LD=$(which gcc-10)

cd protobuf
make install
brew link protobuf
cd ..

