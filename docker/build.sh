#!/bin/bash

CD=$(dirname $(readlink -f $BASH_SOURCE))

# we grab the kernel file and version from the vault.centos.org, for the current release of centos!
kernel=$(curl -L "http://vault.centos.org/$(cat /etc/centos-release | awk '{print $(NF-1)}')/os/Source/SPackages/" | egrep 'kernel.*.src.rpm' | head -1 | awk -F'.rpm">' '{print $2}' | awk -F'.src.rpm</a></td><td' '{print $1}')
kv=$(echo $kernel | awk -F'kernel-' '{print $2}' | awk -F'.src' '{print $1}')

# then we download the kernel source, kernel and kernel devel
cd /root/modules/
( [ ! -f kernel-$kv.src.rpm ] && curl -L -O "http://vault.centos.org/$(cat /etc/centos-release | awk '{print $(NF-1)}')/os/Source/SPackages/kernel-$kv.src.rpm" )
( [ ! -f kernel-$kv.x86_64.rpm ] && curl -L -O "http://vault.centos.org/$(cat /etc/centos-release | awk '{print $(NF-1)}')/os/x86_64/Packages/kernel-$kv.x86_64.rpm" )
( [ ! -f kernel-devel-$kv.x86_64.rpm ] && curl -L -O "http://vault.centos.org/$(cat /etc/centos-release | awk '{print $(NF-1)}')/os/x86_64/Packages/kernel-devel-$kv.x86_64.rpm" )

# and uncompress it
rpm -ivh kernel-$kv.src.rpm && \
rpm -ivh kernel-$kv.x86_64.rpm && \
rpm -ivh kernel-devel-$kv.x86_64.rpm && \
cd /root/rpmbuild/SOURCES/ && \
sudo tar xf linux-*.tar.xz -C /usr/src/kernels/ || \
echo "ERROR uncompressing kernel!!"
ls -l /usr/src/kernels/

# and build!
cd /usr/src/kernels/linux-$kv && \
make mrproper && \
cp /usr/src/kernels/$kv.x86_64/Module.symvers ./ && \
cp /boot/config-$kv.x86_64 ./.config && \
make oldconfig && \
make prepare && \
make scripts
[ $? -ne 0 ] && echo ERRO preparing kernel!! && exit -1

# from here, we build the required module (for nbd, if it fails, we have to patch it!)
make CONFIG_BLK_DEV_NBD=m M=drivers/block || (\
sed -i.bak -e 's/sreq.cmd_type...REQ_TYPE_SPECIAL/sreq.cmd_type=7/' /usr/src/kernels/linux-$kv/drivers/block/nbd.c ; \
make CONFIG_BLK_DEV_NBD=m M=drivers/block )
[ $? -ne 0 ] && echo ERRO building kernel module!! && exit -1

# and copy the module
mkdir -p /root/modules/$kv.x86_64/kernel/drivers/block/
cp drivers/block/nbd.ko /root/modules/$kv.x86_64/kernel/drivers/block/ || \
( echo "ERROR: module nbd.ko was not built." ; /bin/bash -i -l )
