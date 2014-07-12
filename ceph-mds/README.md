ceph-mds
========

This Dockerfile creates a Ceph metadata server (MDS) image


Usage
-----

The environment variable `MDS_NAME` is required.  It describes the name of the MDS

For example:
`docker run -e MDS_NAME=mymds ulexus/ceph-mds`

It will look for either `/etc/ceph/ceph.client.admin.keyring` or `/etc/ceph/ceph.mds.keyring` with which to authenticate.  You can get `ceph.client.admin.keyring` from another ceph node.

Commonly, you will want to bind-mount your host's `/etc/ceph` into the container.  For example:
`docker run -e MDS_NAME=mymds -v /etc/ceph:/etc/ceph ulexus/ceph-mds`

