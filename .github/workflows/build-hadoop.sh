#!/bin/bash

brew install cmake
brew install zlib
brew install protobuf
brew install snappy
brew install homebrew/versions/protobuf250
echo 'export PATH="/usr/local/opt/protobuf@2.5/bin:$PATH"' >> ~/.bashrc
