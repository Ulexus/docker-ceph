#!/bin/bash

# Script to bootstrap ceph monitor
# taken from ceph documentation:
#   http://ceph.com/docs/master/install/manual-deployment/#monitor-bootstrapping
#
# Expected environment variables:
#   MONIP - (IP address of monitor)
#   MONHOST - (hostname of monitor)
# Usage:
#   MONIP=192.168.101.50 MONHOST=mymon docker run ulexus/ceph-mon /usr/local/bin/bootstrap.sh

if [ $# -ne 2 ]; then
   echo "Usage: $0 <monitor-name> <monitor-ip>"
   exit 1
fi

MONHOST=$1
MONIP=$2

if [ ! -e /etc/ceph/ceph.conf ]; then
   fsid=$(uuidgen)
   cat <<ENDHERE >/etc/ceph/ceph.conf
fsid = $(uuidgen)
mon initial members = ${MONHOST}
mon host = ${MONIP}
auth cluster required = cephx
auth service required = cephx
auth client required = cephx
ENDHERE
fi

# Get the FSID for later use
fsid=$(cat /etc/ceph/ceph.conf |grep fsid | cut -d' ' -f3)

if [ ! -e /etc/ceph/ceph.client.admin.keyring ]; then
   # Generate administrator key
   ceph-authtool --create-keyring /etc/ceph/ceph.client.admin.keyring --gen-key -n client.admin --set-uid=0 --cap mon 'allow *' --cap osd 'allow *' --cap mds 'allow'
fi

if [ ! -e /var/lib/ceph/mon/ceph-${MONHOST}/keyring ]; then
   # Create monitor secret key(ring)
   ceph-authtool --create-keyring /tmp/ceph.mon.keyring --gen-key -n mon. --cap mon 'allow *'
   # Import administrator keyring
   ceph-authtool /tmp/ceph.mon.keyring --import-keyring /etc/ceph/ceph.client.admin.keyring
   # Use existing or generate new monitor map
   if [ -e /etc/ceph/monmap ]; then
      cp /etc/ceph/monmap /tmp/monmap
   else
      # Generate monitor map
      monmaptool --create --add ${MONHOST} ${MONIP} --fsid ${fsid} /tmp/monmap
   fi
   # Make the monitor directory
   mkdir -p /var/lib/ceph/mon/ceph-${MONHOST}
   # Populate the monitor daemon's directory with the map and keyring
   ceph-mon --mkfs -i ${MONHOST} --monmap /tmp/monmap --keyring /tmp/ceph.mon.keyring
fi

exec /usr/bin/ceph-mon -d -i ${MONHOST} --public-addr ${MONIP}:6789
