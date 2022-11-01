#!/bin/bash

set -e

# don't install ISA-L as it's causing issues during compile
brew install gcc@10 cmake autoconf automake libtool snappy maven zstd cyrus-sasl gzip bzip2 zlib openssl@1.1

brew link zstd
brew link snappy