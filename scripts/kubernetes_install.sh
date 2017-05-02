#!/bin/bash -xe
exec > >(tee -i /tmp/"$(basename "$0" .sh)"_"$(date '+%Y-%m-%d_%H-%M-%S')".log) 2>&1

# Create and distribute SSL certificates for services using salt state
salt --state-output=terse '*' state.sls salt

# Install keepalived
salt --state-output=terse -C 'I@keepalived:cluster' state.sls keepalived -b 1

# Install haproxy
salt --state-output=terse -C 'I@haproxy:proxy' state.sls haproxy
salt --state-output=terse -C 'I@haproxy:proxy' service.status haproxy

# Install docker
salt --state-output=terse -C 'I@docker:host' state.sls docker.host
salt --state-output=terse -C 'I@docker:host' cmd.run "docker ps"

# Install etcd
salt --state-output=terse -C 'I@etcd:server' state.sls etcd.server.service
salt --state-output=terse -C 'I@etcd:server' cmd.run ". /var/lib/etcd/configenv && etcdctl cluster-health"

# Install Kubernetes and Calico
salt --state-output=terse -C 'I@kubernetes:master' state.sls kubernetes.master.kube-addons
salt --state-output=terse -C 'I@kubernetes:pool' state.sls kubernetes.pool
salt --state-output=terse -C 'I@kubernetes:pool' cmd.run "calicoctl node status"
salt --state-output=terse -C 'I@kubernetes:pool' cmd.run "calicoctl get ippool"

# Setup NAT for Calico
salt --state-output=terse -C 'I@kubernetes:master' --subset 1 state.sls etcd.server.setup

# Run whole master to check consistency
salt --state-output=terse -C 'I@kubernetes:master' state.sls kubernetes exclude=kubernetes.master.setup

# Register addons
salt --state-output=terse -C 'I@kubernetes:master' --subset 1 state.sls kubernetes.master.setup

# Nginx needs to be configured
#salt --state-output=terse -C 'I@nginx:server' state.sls nginx
# IMHO not related to k8s installation
