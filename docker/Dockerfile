
# we can use any centos as base image...
# but we choose to use the pipvfx_pkgs
# one since we have it!

ARG PACKAGES
ARG BASE_IMAGE
ARG http
ARG https

FROM $BASE_IMAGE
#FROM centos:7.6.1810


ENV http_proxy=$http
ENV https_proxy=$https
ENV package_image=$PACKAGES

# yum parallel download
RUN [ ! -e /etc/yum/pluginconf.d/multithread.conf ] && \
    curl -O https://raw.githubusercontent.com/mjschultz/yum-multithread/master/multithread.py && \
    curl -O https://raw.githubusercontent.com/mjschultz/yum-multithread/master/multithread.conf && \
    mv ./multithread.py /usr/lib/yum-plugins && \
    mv ./multithread.conf /etc/yum/pluginconf.d/multithread.conf || \
    echo "done"

# RUN echo yum update -y && yum install -y csh tcsh xz \
#     nano libXp libXmu libXpm libXi libtiff libpng12 \
#     xorg-x11-server-Xorg xorg-x11-server-Xvfb xorg-x11-fonts* \
#     libXinerama-devel libXext-devel libXrandr-devel libXi-devel \
#     libXcursor-devel libXxf86vm-devel libXinerama \
#     mesa-utils mesa-libGL-devel mesa-libGLU  mesa-libGLU-devel SDL \
#     git gcc gcc-c++ make scons binutils elfutils dbus-devel glibc-devel \
#     readline-devel dbus-glib-devel cmake yaml-cpp* tinyxml* enca \
#     tkinter ncurses ncurses-devel ncurses-static libcurl-devel \
#     flex-devel sqlite-devel libdb-devel gdbm-devel \
#     gstreamer-plugins-base.x86_64 gamin zip wget \
#     freetype2 vulkan-devel python2-scons

RUN yum groupinstall -y "Development Tools"

RUN yum -y install epel-release
# remove mirrors from epel or else it will fail if there are no mirrors
# in the country the build machine is running
# RUN cat /etc/yum.repos.d/epel.repo \
#     | sed 's/.baseurl/baseurl/' \
#     | sed 's/metalink/#metalink/' > /tmp/epel.repo && \
#     /bin/mv /tmp/epel.repo /etc/yum.repos.d/epel.repo


# install gcc 6.3.1
# RUN yum -y install centos-release-scl devtoolset-6
# add default to gcc 6.3.1 to /etc/bashrc, so running bash will automatically set it
# RUN printf "\nsource scl_source enable devtoolset-6\n" >> /etc/bashrc

RUN yum -y install sudo
RUN yum -y install patchelf

# install kernel on this image, so we can grab .config from it!
RUN yum -y install initscripts grubby linux-firmware
RUN yum -y install elfutils-libelf-devel

# cleanup
RUN yum clean all
RUN rm -rf /var/cache/yum/*
ENV TERM=xterm

RUN ln -s /lib64/libbz2.so.1 /lib64/libbz2.so.1.0 ; \
    ln -s libcrypto.so.1.0.2k /usr/lib64/libcrypto.so.10 ; \
    ln -s libcrypto.so.0.9.8e /usr/lib64/libcrypto.so.6 ; \
    ln -s libssl.so.1.0.2k /usr/lib64/libssl.so.10 ; \
    ln -s libssl.so.0.9.8e /usr/lib64/libssl.so.6 ; \
    ln -s /usr/bin/ar /usr/sbin/ar ; \
    ln -s /usr/bin/ranlib /usr/sbin/ranlib

ADD build.sh /build.sh
ENTRYPOINT "/build.sh"
