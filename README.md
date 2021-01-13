# centos-nbd-kernel-module
Build the NBD kernel module for centos 7 using docker.
This can be used as a base to build any centos 7 module actually.

It downloads the proper kernel source from vault.centos.org for the version
of centos found on /etc/release.

One can force a specific version as an argument for make.sh:
```
    centos version: make.sh -c 7.6.1810

```
