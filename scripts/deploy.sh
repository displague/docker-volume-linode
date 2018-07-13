#!/bin/bash

set -ev

##############################
export PLUGIN_NAME_ROOTFS=docker-volume-linode:rootfs-${TRAVIS_BUILD_NUMBER}
export PLUGIN_NAME=libgolang/docker-volume-linode:${TRAVIS_BRANCH}.${TRAVIS_BUILD_NUMBER}
export PLUGIN_NAME_TAR=docker-volume-linode_${TRAVIS_BRANCH}.${TRAVIS_BUILD_NUMBER}.tar

##############################
echo "$DOCKER_PASSWORD" | docker login -u libgolang --password-stdin
docker plugin push ${PLUGIN_NAME}

