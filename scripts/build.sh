#!/bin/bash

set -ev

##############################
export PLUGIN_NAME_ROOTFS=docker-volume-linode:rootfs-${TRAVIS_BUILD_NUMBER}
export PLUGIN_NAME=docker-volume-linode:${TRAVIS_BRANCH}.${TRAVIS_BUILD_NUMBER}
export PLUGIN_NAME_TAR=docker-volume-linode_${TRAVIS_BRANCH}.${TRAVIS_BUILD_NUMBER}.tar

##############################
go get -u github.com/golang/dep/cmd/dep
##############################
dep ensure
##############################
echo "docker build --no-cache -q -t ${PLUGIN_NAME_ROOTFS} ."
docker build --no-cache -q -t ${PLUGIN_NAME_ROOTFS} .
##############################
mkdir -p ./plugin/rootfs
##############################
echo "docker create --name tmp  ${PLUGIN_NAME_ROOTFS}"
docker create --name tmp  ${PLUGIN_NAME_ROOTFS}
##############################
docker export tmp | tar -x -C ./plugin/rootfs
##############################
cp config.json ./plugin/
##############################
docker rm -vf tmp
##############################
echo "docker plugin rm -f ${PLUGIN_NAME} || true"
docker plugin rm -f ${PLUGIN_NAME} || true
##############################
echo "docker plugin create ${PLUGIN_NAME} ./plugin"
docker plugin create ${PLUGIN_NAME} ./plugin
##############################
echo "docker save -o ${PLUGIN_NAME_TAR} ${PLUGIN_NAME}"
docker save -o ${PLUGIN_NAME_TAR} ${PLUGIN_NAME}
##############################
