#!/usr/bin/env bash

CD=$(dirname $(readlink -f $BASH_SOURCE))

# base image from centos used
base_centos=centos:7.6.1810

# build centos image to build kernel module
cd $CD/docker
docker build \
            -f $CD/docker/Dockerfile \
            $CD/docker/ \
            -t centos-nbd-kernel-module:latest \
            --pull \
            --compress \
            --rm \
            --build-arg http="$http_proxy" \
            --build-arg https="$https_proxy" \
            --build-arg BASE_IMAGE="$base_centos"



docker run -ti \
    -v $CD/modules/:/root/modules/ \
centos-nbd-kernel-module:latest
