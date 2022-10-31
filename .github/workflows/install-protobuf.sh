#!/bin/bash

cd protobuf \
 && make install \
 && brew link protobuf \
 && cd .. \
 && exit 1

