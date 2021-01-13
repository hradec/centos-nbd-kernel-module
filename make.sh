#!/usr/bin/env bash

CENTOS_VERSION=7.6.1810
while getopts c: option ; do
    case "${option}"
    in
        c) CENTOS_VERSION="${OPTARG}";;
    esac
done

CD=$(dirname $(readlink -f $BASH_SOURCE))

# base image from centos used
base_centos=centos:$CENTOS_VERSION

# build centos image to build kernel module
cd $CD/docker
docker build \
            -f $CD/docker/Dockerfile \
            $CD/docker/ \
            -t centos-nbd-kernel-module:$CENTOS_VERSION \
            --pull \
            --compress \
            --rm \
            --build-arg http="$http_proxy" \
            --build-arg https="$https_proxy" \
            --build-arg BASE_IMAGE="$base_centos"


# now run and build our module
docker run -ti \
    -v $CD/modules/:/root/modules/ \
centos-nbd-kernel-module:$CENTOS_VERSION
