#!/bin/bash

export PLUGIN_NAME_ROOTFS=docker-volume-linode:rootfs-${TRAVIS_BUILD_NUMBER}
export PLUGIN_NAME=docker-volume-linode:${TRAVIS_BRANCH}.${TRAVIS_BUILD_NUMBER}

go get -u github.com/golang/dep/cmd/dep
dep ensure
docker build --no-cache -q -t ${PLUGIN_NAME_ROOTFS} .
mkdir -p ./plugin/rootfs
docker create --name tmp  ${PLUGIN_NAME_ROOTFS}
docker export tmp | tar -x -C ./plugin/rootfs
cp config.json ./plugin/
docker rm -vf tmp
docker plugin rm -f ${PLUGIN_NAME} || true
docker plugin create ${PLUGIN_NAME} ./plugin
