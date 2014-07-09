# DOCKER-VERSION 1.0.0
# 
# Ceph base image
#
#  USAGE NOTES:
#    - EITHER use a VOLUME (preferably from ceph-config) OR the ADD
#    - IF using ADD: Copy your ceph.conf, keyrings, etc into the config/ directory before building
#
# VERSION 0.0.1


FROM stackbrew/ubuntu:trusty
MAINTAINER Seán C McCord "ulexus@gmail.com"

# Make sure we are up-to-date
RUN apt-get update
RUN apt-get upgrade -y

# Install ceph
RUN apt-get install -y ceph
