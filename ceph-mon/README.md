ceph-mon
========

This Dockerfile is for use in bootstrapping an initial Ceph MON for use with Docker [ http://docker.io/ ].

Install Docker
--------------
```
Using Ubuntu 13.04 (64 bit)
```

```
# Enable AUFS filesystem support
sudo apt-get update
sudo apt-get install linux-image-extra-`uname -r`
```

```
# Install Docker
sudo sh -c "curl http://get.docker.io/gpg | apt-key add -"
sudo sh -c "echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install lxc-docker
```


Build Ceph MON Container
------------------------
```
# Build Container
sudo docker build github.com/ceph-docker/ceph-mon
```
